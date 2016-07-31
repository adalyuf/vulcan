require 'ostruct'

class Struct

  def to_hash
    {}.tap do |r|
      members.each do |member|
        r[member] = self[member]
      end
    end
  end

  def merge(other)
    self.class.from_hash(to_hash.merge(other.to_hash))
  end

  def merge!(other)
    self.from_hash!(to_hash.merge(other.to_hash))
  end

  def blank?
    self.members.all? { |member| self[member].blank? }
  end

  def present?
    ! self.blank?
  end

end

class OpenStruct

  def to_hash
    {}.tap do |r|
      @table.each do |k, v|
        if v.is_a?(OpenStruct) || v.is_a?(Struct)
          r[k] = v.to_hash
        else
          r[k] = v
        end
      end
    end
  end

  # recursive
  def self.from_hash(object)
    case object
    when Hash
      object.each do |key, value|
        object[key] = from_hash(value)
      end
      new(object)
    when Array
      object.map { |i| from_hash(i) }
    else
      object
    end
  end

end
