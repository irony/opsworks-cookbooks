node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'nodejs'
    Chef::Log.debug("Skipping deploy::nodejs application #{application} as it is not a node.js app")
    next
  end

  directory "#{deploy[:deploy_to]}/shared/node_modules/config" do
    owner deploy[:user]
    group deploy[:group]
    mode '0660'
    action :create
  end

  link "#{deploy[:deploy_to]}/shared/node_modules/" do
    to "#{deploy[:deploy_to]}/current/node_modules/"
    action :create
  end

  template "#{deploy[:deploy_to]}/shared/node_modules/config/index.js" do
    cookbook 'opsworks_nodejs'
    source 'opsworks.js.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(:config => deploy, :layers => node[:opsworks][:layers])
  end
end
