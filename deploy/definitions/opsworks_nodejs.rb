define :opsworks_nodejs do
  deploy = params[:deploy_data]
  application = params[:app]

  service 'monit' do
    action :nothing
  end

  Chef::Log.info("Running npm install.")
  Chef::Log.info(`sudo su #{app_config[:user]} -c 'cd #{app_root_path} && npm install --production' 2>&1`)
  
  template "#{deploy[:deploy_to]}/shared/config/config.json" do
    cookbook 'opsworks_nodejs'
    source 'opsworks.js.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(:config => deploy, :layers => node[:opsworks][:layers])
  end

  link "#{deploy[:deploy_to]}/shared/config/config.json" do
    to "#{deploy[:deploy_to]}/current/config.json"
    group deploy[:group]
    owner deploy[:user]
  end

  template "#{node.default[:monit][:conf_dir]}/node_web_app-#{application}.monitrc" do
    source 'node_web_app.monitrc.erb'
    cookbook 'opsworks_nodejs'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      :deploy => deploy,
      :application_name => application,
      :monitored_script => "#{deploy[:deploy_to]}/current/index.js"
    )
    notifies :restart, "service[monit]", :immediately
  end
end
