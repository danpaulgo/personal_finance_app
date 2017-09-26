module AssetsHelper

  all_asset_types = ResourceType.where(resource_name_id: 1)
  liquid_asset_names = ["Cash", "Bank Account", "Stock", "Fund"]
  LIQUID_ASSET_TYPES = []
  liquid_asset_names.each do |name|
    LIQUID_ASSET_TYPES += all_asset_types.where(name: name)
  end

  illiquid_asset_names = ["Real Estate", "Vehicle", "Artwork", "Jewelry", "Collectible"]
  ILLIQUID_ASSET_TYPES = []
  illiquid_asset_names.each do |name|
    ILLIQUID_ASSET_TYPES += all_asset_types.where(name: name)
  end

end
