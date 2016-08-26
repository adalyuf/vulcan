class CreateMarital < ActiveRecord::Migration[5.0]
  def change
    create_table :maritals do |t|
      t.text :name
      t.text :description
      t.timestamps
    end

    Marital.where(name: "Not specified", description: "Marital status not specified or not applicable to this series").first_or_create
    Marital.where(name: "All marital statuses", description: "All values for marital status were included in this series").first_or_create
    Marital.where(name: "Annulled", description: "Marriage contract has been declared null and to not have existed").first_or_create
    Marital.where(name: "Divorced", description: "Marriage contract has been declared dissolved and inactive").first_or_create
    Marital.where(name: "Divorce proceeding", description: "Divorce proceedings have begun but not concluded. Also called interlocutory").first_or_create
    Marital.where(name: "Legally separated", description: "Legally separated").first_or_create
    Marital.where(name: "Married", description: "A marriage contract is currently active, spouses intend to live together").first_or_create
    Marital.where(name: "Polygamous", description: "More than one current spouse").first_or_create
    Marital.where(name: "Never married", description: "No marriage contract has ever been entered").first_or_create
    Marital.where(name: "Domestic partner", description: "Person declared that a domestic partner relationship exists").first_or_create
    Marital.where(name: "Spouse absent", description: "Married, but not living together").first_or_create
    Marital.where(name: "Answer not given", description: "The question of marital status was posed but no answer was provided").first_or_create


    add_index :maritals, :name, unique: true
    add_column :series, :marital_raw, :text
    add_reference :series, :marital, foreign_key: true, null: false
  end
end
