rule("valgrind")
on_test(function(target, opt)
	import("lib.detect.find_program")

	local valgrind = assert(find_program("valgrind"), "valgrind is required to run the tests")
	local argv = {
		"--error-exitcode=99",
		"--leak-check=full",
		"--show-leak-kinds=all",
		"--errors-for-leak-kinds=definite,indirect",
		target:targetfile(),
	}

	local runargs = opt.runargs
	if type(runargs) == "string" then
		runargs = os.argv(runargs)
	end
	for _, arg in ipairs(runargs or {}) do
		table.insert(argv, arg)
	end

	os.execv(valgrind, argv, {
		curdir = opt.rundir,
		envs = opt.runenvs,
	})
	return true
end)
rule_end()
