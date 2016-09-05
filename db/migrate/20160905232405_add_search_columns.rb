class AddSearchColumns < ActiveRecord::Migration[5.0]
  def up
    add_column :indicators, :tsv, :tsvector
    add_index :indicators, :tsv, using: "gin"

    ActiveRecord::Base.connection.execute("
      CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
      ON indicators FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(
        tsv, 'pg_catalog.english', name, description
      );
    ")

    now = Time.current.to_s(:db)
    update("UPDATE indicators SET updated_at = '#{now}'")
  end

  def down
    ActiveRecord::Base.connection.execute("
      DROP TRIGGER tsvectorupdate
      ON indicators
    ")

    remove_index :indicators, :tsv
    remove_column :indicators, :tsv
  end
end
