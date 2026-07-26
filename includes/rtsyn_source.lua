function rtsyn_source(package_name, remote_url)
	local workspace = os.getenv("RTSYN_WORKSPACE")

	if workspace then
		set_sourcedir(path.join(workspace, package_name))
	else
		add_urls(remote_url)
	end
end
