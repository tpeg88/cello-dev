class Project < ActiveRecord::Base
  validates :title, :description, :owner, presence: true
  belongs_to :owner, {
    class_name: "User",
    foreign_key: :owner_id,
    primary_key: :id,
    inverse_of: :owned_projects
  }
  
  has_many :memberships, class_name: "ProjectMembership", inverse_of: :project
  has_many :members, through: :memberships, source: :user
end