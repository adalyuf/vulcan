# SOURCES = [
#   { name: 'Bureau of Economic Analysis', internal_name: 'bea', datasets_attributes: [
#     { name: 'Fixed Assets', internal_name: 'fixed_assets' },
#     { name: 'NIPA (National Income and Product Accounts)', internal_name: 'nipa' },
#     { name: 'Regional Data (statistics by state, county, and MSA)', internal_name: :regional_data }]
#   }]

# SOURCES.each do |source|
#   Source.where(name: source[:name]).first_or_create(source)
# end
