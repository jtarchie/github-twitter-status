module DashboardHelper
  def authorize_button(user, service)
    link_to "/auth/#{service.downcase}", class: "btn btn-primary btn-large" do
      content_tag(:i, "", class: "#{user.github_uid.present? ? "icon-ok" : "icon-plus-sign"} icon-white") +
        service.capitalize
    end
  end
end
