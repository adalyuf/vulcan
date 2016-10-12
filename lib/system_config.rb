class SystemConfig
  include Singleton

  def initialize
    system_config = self.class.load_config_file(File.join(Rails.root, 'config', 'system.yml'))
    system_yaml = YAML::load(system_config.to_yaml)
    @configs = OpenStruct.from_hash(system_yaml)
  end

  def self.method_missing(method, *args)
    self.instance.send(method, *args)
  end

  def method_missing(method, *args)
    @configs.send(method, *args)
  end

  def self.load_config_file(file)
    YAML::load ERB.new(IO.read(file)).result
  end

  def self.trial_scope_end_date
    self.trial.scope_end.to_date
  end
end
