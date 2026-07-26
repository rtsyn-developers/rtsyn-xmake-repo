function rtsyn_source(package_name, remote_url, version)
	local workspace = os.getenv("RTSYN_WORKSPACE")

	if workspace then
		set_sourcedir(path.join(workspace, package_name))
	else
		if not version or version == "" then
			raise(package_name .. " requires a source version")
		end
		add_urls(remote_url)
		add_versions(version, "v" .. version)
	end
end
