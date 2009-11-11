class OperationObserver < ActiveRecord::Observer
  observe :position, :profile

  def after_create model
    Operation.create :event => model.event(:created)
  end

  def after_update model
    Operation.create :event => model.event(:updated)
  end

  def after_destroy model
  end

end
