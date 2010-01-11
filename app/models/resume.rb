class Resume < ActiveRecord::Base
  belongs_to :profile

  has_attached_file :file
  validates_attachment_content_type :file,
    :content_type => [%r'application/(msword|pdf)', %r'application/vnd.openxmlformats-officedocument.wordprocessingml.document', %r'text/(plain|html)'],
    :message => I18n.t('activerecord.errors.models.resume.attributes.file.invalid_content_type')
end
