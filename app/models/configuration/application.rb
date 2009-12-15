class Configuration::Application < Configuration
  support_group!

  preference :per_page, :integer, :default => 20
  preference :fold_positions, :boolean, :default => true

  def set(preferences={}, group=nil)
    preferences[:fold_positions] = !!preferences[:fold_positions]
    super
  end
end
