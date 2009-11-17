class PositionObserver < ActiveRecord::Observer

  def after_create position
    Operation.create \
      :operator => position.creator,
      :event => "_#{position.creator.displayname}_ has added " \
                "a new position #{name_for position} " \
                "at #{I18n.l position.created_at, :format => :short}."
  end

  def after_update position
    Operation.create \
      :operator => position.creator,
      :event => "_#{position.creator.displayname}_ has updated " \
                "a new position #{name_for position} " \
                "at #{I18n.l position.updated_at, :format => :short}."
  end

  private
  def name_for position
    "[#{position.name}]({{position_profiles_path #{position.id}}})(#{position.category.name})"
  end

end
