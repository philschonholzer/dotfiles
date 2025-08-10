-- https://biomejs.dev/internals/language-support/
local supported = {
	"astro",
	"css",
	"graphql",
	-- "html",
	"javascript",
	"javascriptreact",
	"json",
	"jsonc",
	-- "markdown",
	"svelte",
	"typescript",
	"typescriptreact",
	"vue",
	-- "yaml",
}
return {
	"stevearc/conform.nvim",
	optional = true,
	---@param opts ConformOpts
	opts = function(_, opts)
		opts.formatters_by_ft = opts.formatters_by_ft or {}
		for _, ft in ipairs(supported) do
			opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
			table.insert(opts.formatters_by_ft[ft], "biome-check")
		end

		opts.formatters = opts.formatters or {}
		opts.formatters["biome-check"] = {
			require_cwd = true,
		}
	end,
}
