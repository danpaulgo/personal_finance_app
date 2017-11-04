module AssetsHelper

  all_asset_types = ResourceType.where(resource_name_id: 1)
  liquid_asset_names = ["Cash", "Bank Account", "Stock", "Fund"]
  liquid_asset_types_array = []
  liquid_asset_names.each do |name|
    liquid_asset_types_array += all_asset_types.where(name: name)
  end

  LIQUID_ASSET_TYPES = liquid_asset_types_array

  illiquid_asset_names = ["Property", "Vehicle", "Artwork", "Jewelry", "Collectible"]
  illiquid_asset_types_array = []
  illiquid_asset_names.each do |name|
    illiquid_asset_types_array += all_asset_types.where(name: name)
  end

  ILLIQUID_ASSET_TYPES = illiquid_asset_types_array

end
