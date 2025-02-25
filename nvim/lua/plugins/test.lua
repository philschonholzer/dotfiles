return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"marilari88/neotest-vitest",
			"nvim-neotest/neotest-jest",
		},
		opts = { adapters = { "neotest-jest", ["neotest-vitest"] = {} } },
	},
}
