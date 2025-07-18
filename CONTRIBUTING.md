# Contributing to Octo.Nvim

Welcome to Octo! This document is a guideline about how to contribute to Octo.
If you find something incorrect or missing, please leave comments / suggestions.

## Before you get started

### Code of Conduct

Please make sure to read and observe our [Code of Conduct](./CODE_OF_CONDUCT.md).

### Setting up your development environment

You should have the following installed in your system:

- Neovim >= 0.10.0
- GitHub CLI (`gh`) - required for authentication and API access
- Git - for version control
- `stylua` - for code formatting (install via `cargo install stylua` or your package manager)
- TODO(determine why this is installed in tests.yml workflow) `fd-find` - for file searching (optional but recommended)

For testing:

- plenary.nvim - will be automatically installed when running tests
- `lua-language-server` - for type checking (optional but recommended)

## Testing

Octo.nvim uses the [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) test framework for testing.

### Test Structure

Tests are located in the `lua/tests/` directory with the following structure:

- `lua/tests/plenary/` - Main test files using plenary's framework
  - `config_spec.lua` - Configuration module tests
  - `gh_spec.lua` - GitHub CLI integration tests
  - `utils_spec.lua` - Utility function tests
  - `autocommand_spec.lua` - Autocommand tests
- `lua/tests/minimal_init.vim` - Test initialization script
- `lua/tests/test_utils.lua` - Test helper functions

### Running Tests

To run all tests:

```bash
nvim --headless -c "PlenaryBustedDirectory lua/tests/plenary/ {minimal_init = 'lua/tests/minimal_init.vim'}"
```

To run a specific test file:

```bash
nvim --headless -c "PlenaryBustedFile lua/tests/plenary/config_spec.lua {minimal_init = 'lua/tests/minimal_init.vim'}"
```

### Writing Tests

Tests follow a BDD (Behavior Driven Development) style using `describe` and `it` blocks:

```lua
describe("Module name", function()
  describe("function_name", function()
    it("does something specific", function()
      -- Arrange
      local input = "test"

      -- Act
      local result = module.function_name(input)

      -- Assert
      assert.equals("expected", result)
    end)
  end)
end)
```

### Test Dependencies

- **Neovim** >= 0.10.0
- **plenary.nvim** - Test framework (automatically installed in CI)
- TODO(determine why this is installed in tests.yml workflow) `fd-find` - File search utility (for some tests)

### Best Practices

1. **Write tests for new features**: All new functionality should include tests
2. **Test edge cases**: Include tests for error conditions and boundary values
3. **Keep tests focused**: Each test should verify one specific behavior
4. **Use descriptive names**: Test descriptions should clearly state what is being tested
5. **Mock external dependencies**: Use test utilities to mock GitHub API calls
6. **Run tests locally**: Always run tests before submitting a PR

### Test Utilities

The `lua/tests/test_utils.lua` file provides helper functions:

- `feed()` - Simulate keyboard input
- `insert()` - Insert text at cursor position
- `Test_filter` - Filter test execution
- `Test_withfile` - Test with temporary files

## Type Checking

We use [lua-language-server](https://github.com/LuaLS/lua-language-server) for static type checking. The project includes:

- `.github/workflows/typecheck.yml` - CI workflow that runs type checking on every PR
- `.github/workflows/.luarc.json` - Configuration for lua-language-server with project-specific settings

Ensure your code includes proper [LuaCATS type annotations](https://luals.github.io/wiki/annotations/):

```lua
---@param repo string The repository name
---@param number integer The issue/PR number
---@return OctoBuffer|nil
function M.get_buffer(repo, number)
  -- implementation
end
```

For convenience, you can use `lua-language-server` in your editor which will provide real-time type checking using the project's type annotations, but you can also typecheck the entire project locally:

1. Install `lua-language-server`:

   ```bash
   # Download and extract (adjust version as needed)
   mkdir -p luals
   curl -L "https://github.com/LuaLS/lua-language-server/releases/download/3.15.0/lua-language-server-3.15.0-linux-x64.tar.gz" | tar zx --directory luals
   export PATH="$PWD/luals/bin:$PATH"
   ```

2. Clone dependencies (required for type checking):

   ```bash
   mkdir -p deps
   git clone --depth 1 https://github.com/nvim-lua/plenary.nvim deps/plenary.nvim
   git clone --depth 1 https://github.com/folke/snacks.nvim deps/snacks.nvim
   git clone --depth 1 https://github.com/nvim-telescope/telescope.nvim deps/telescope.nvim
   git clone --depth 1 https://github.com/ibhagwan/fzf-lua deps/fzf-lua
   git clone --depth 1 https://github.com/nvim-tree/nvim-web-devicons deps/nvim-web-devicons
   git clone --depth 1 https://github.com/Bilal2453/luvit-meta deps/luvit-meta
   ```

3. Run type checking:

   ```bash
   # Set VIMRUNTIME to your Neovim runtime path
   export VIMRUNTIME=/path/to/neovim/share/nvim/runtime

   # Run the type checker
   lua-language-server --check=./lua --configpath=./.github/workflows/.luarc.json --checklevel=Information
   ```

## Contributing

We are always very happy to have contributions, whether for typo fix, bug fix or big new features.
Please do not ever hesitate to ask a question or send a pull request.

### GitHub workflow

We use the `master` branch as the development branch, which indicates that this is a unstable branch.

Here are the workflow for contributors:

1. Fork to your own
2. Clone fork to local repository
3. Create a new branch and work on it
4. Keep your branch in sync
5. Commit your changes (make sure your commit message concise)
6. Push your commits to your forked repository
7. Create a pull request

Please follow [the pull request template](./.github/PULL_REQUEST_TEMPLATE.md).
Please make sure the PR has a corresponding issue.

After creating a PR, one or more reviewers will be assigned to the pull request.
The reviewers will review the code.

Before merging a PR, squash any fix review feedback, typo, merged, and rebased sorts of commits.
The final commit message should be clear and concise.

### Open an issue / PR

We use [GitHub Issues](https://github.com/pwntester/octo.nvim/issues) and [Pull Requests](https://github.com/pwntester/octo.nvim/pulls) for trackers.

If you find a typo in document, find a bug in code, or want new features, or want to give suggestions,
you can [open an issue on GitHub](https://github.com/pwntester/octo.nvim/issues/new) to report it.
Please follow the guideline message in the issue template.

If you want to contribute, please follow the [contribution workflow](#github-workflow) and create a new pull request.
If your PR contains large changes, e.g. component refactor or new components, please write detailed documents
about its design and usage.

Note that a single PR should not be too large. If heavy changes are required, it's better to separate the changes
to a few individual PRs.

### Code review

All code should be well reviewed by one or more committers. Some principles:

- Readability: Important code should be well-documented. Comply with our code style.
- Elegance: New functions, classes or components should be well designed.
