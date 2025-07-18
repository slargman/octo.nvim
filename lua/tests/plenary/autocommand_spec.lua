---@diagnostic disable
local octo = require "octo"
local eq = assert.are.same

describe("OctoBufferCreated autocommand:", function()
  before_each(function()
    -- Setup octo plugin
    octo.setup {}
  end)

  it("fires when opening a repo buffer", function()
    -- Track if the autocommand fired and capture its data
    local autocmd_fired = false
    local bufnr = nil
    local captured_data = nil

    -- Create an autocommand listener for OctoBufferCreated
    vim.api.nvim_create_autocmd("User", {
      pattern = "OctoBufferCreated",
      callback = function(args)
        autocmd_fired = true
        bufnr = args.buf
        captured_data = args.data
      end,
    })

    -- Mock repository data
    local mock_repo = {
      id = "test-repo-id",
      name = "octo.nvim",
      nameWithOwner = "pwntester/octo.nvim",
      owner = { login = "pwntester" },
      description = "Edit and review GitHub issues and pull requests from the comfort of your favorite editor",
      defaultBranchRef = { name = "main" },
      isPrivate = false,
      diskUsage = 1000,
      createdAt = "2020-01-01T00:00:00Z",
      updatedAt = "2023-01-01T00:00:00Z",
      pushedAt = "2023-01-01T00:00:00Z",
      url = "https://github.com/pwntester/octo.nvim",
      sshUrl = "git@github.com:pwntester/octo.nvim.git",
      homepageUrl = "",
      stargazerCount = 1000,
      forkCount = 100,
      hasIssuesEnabled = true,
      hasProjectsEnabled = true,
      hasWikiEnabled = true,
    }

    -- Create a repo buffer
    octo.create_buffer("repo", mock_repo, "pwntester/octo.nvim", true)

    -- Wait a bit for async operations
    vim.wait(100)

    -- Assert the autocommand fired
    eq(autocmd_fired, true, "OctoBufferCreated autocommand should have fired")

    -- Assert the data passed to the autocommand
    assert(captured_data ~= nil, "Autocommand data should not be nil")
    eq(captured_data.kind, "repo", "Buffer kind should be 'repo'")
    eq(captured_data.repo, "pwntester/octo.nvim", "Repo should match")
    eq(captured_data.owner, "pwntester", "Owner should match")
    eq(captured_data.name, "octo.nvim", "Name should match")
    assert(type(captured_data.bufnr) == "number", "bufnr should be a number")

    -- Verify we received the repo object but didn't get internal buffer details
    eq(captured_data.object.nameWithOwner, "pwntester/octo.nvim", "Object should contain repo data")
    eq(captured_data.buffer, nil, "Internal buffer instance should not be exposed")
  end)
end)

