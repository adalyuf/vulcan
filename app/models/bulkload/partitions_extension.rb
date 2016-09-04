module Bulkload::PartitionsExtension
  extend ActiveSupport::Concern
  module ClassMethods
    def create_schemas
      ActiveRecord::Base.connection.execute("create schema values_partitions")
    end

    def drop_schemas
      ActiveRecord::Base.connection.execute("DROP SCHEMA IF EXISTS values_partitions CASCADE")
    end

    def create_triggers
      ActiveRecord::Base.connection.execute("
        CREATE OR REPLACE FUNCTION values_insert_trigger()
        RETURNS TRIGGER AS $$
        BEGIN
          RAISE EXCEPTION 'This table does not allow inserts. Insert directly into child partition tables in values_partitions';
        END;
        $$
        LANGUAGE plpgsql;
        ")

      ActiveRecord::Base.connection.execute("
        CREATE TRIGGER insert_values_trigger
        BEFORE INSERT ON values
        EXECUTE PROCEDURE values_insert_trigger();
      ")
    end

    def drop_triggers
      ActiveRecord::Base.connection.execute("DROP TRIGGER IF EXISTS insert_values_trigger ON values;")
      ActiveRecord::Base.connection.execute("DROP FUNCTION IF EXISTS values_insert_trigger();")
    end

    def create_value_partitions
      ids = Indicator.ids
      ids.each do |id|
        unless (ActiveRecord::Base.connection.data_source_exists?("values_partitions.p#{ id }"))
          ActiveRecord::Base.connection.execute("create table values_partitions.p#{ id } (CHECK ( indicator_id = #{ id } )) inherits (values)")
        end
      end
    end

    def drop_value_partitions
      ids = Indicator.ids
      ids.each do |id|
        begin
          ActiveRecord::Base.connection.execute("drop table values_partitions.p#{ id }")
        rescue ActiveRecord::StatementInvalid => e
          puts "Error: #{ e }"
        end
      end
    end

    def truncate_indicators
      ActiveRecord::Base.connection.execute("TRUNCATE TABLE indicators CASCADE;")
      # Cascade option forcefully truncates all objects that have relationships with indicators (series, values)
    end

    def truncate_series
      ActiveRecord::Base.connection.execute("TRUNCATE TABLE series CASCADE;")
    end

    def reset
      drop_value_partitions
      drop_schemas
      drop_triggers
      truncate_indicators
      truncate_series
    end
  end
end