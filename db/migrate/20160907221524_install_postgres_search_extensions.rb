class InstallPostgresSearchExtensions < ActiveRecord::Migration[5.0]
  def up
    ActiveRecord::Base.connection.execute("CREATE EXTENSION pg_trgm;")
    ActiveRecord::Base.connection.execute("CREATE EXTENSION fuzzystrmatch;")
  end

  def down
    ActiveRecord::Base.connection.execute("DROP EXTENSION pg_trgm;")
    ActiveRecord::Base.connection.execute("DROP EXTENSION fuzzystrmatch;")
  end
end
