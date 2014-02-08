define :opsworks_nodejs do
  deploy = params[:deploy_data]
  application = params[:app]

  service 'monit' do
    action :nothing
  end

  node[:dependencies][:npms].each do |npm, version|
    execute "/usr/local/bin/npm install #{npm}" do
      cwd "#{deploy[:deploy_to]}/current"
    end
  end
  
  directory "#{deploy[:deploy_to]}/shared/node_modules/config" do
    owner deploy[:user]
    group deploy[:group]
    mode '0660'
    action :create
  end

  template "#{deploy[:deploy_to]}/shared/node_modules/config/index.js" do
    cookbook 'opsworks_nodejs'
    source 'opsworks.js.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(:deploy => deploy, :layers => node[:opsworks][:layers])
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
