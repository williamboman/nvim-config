local Result = require("mason-core.result")
local _ = require "mason-core.functional"
local fetch = require("mason-core.fetch")
local registry_api = require("mason-registry.api")
local serializer = require "mason-plugin.serializer"
local spawn = require "mason-core.spawn"

local PACKAGE_TEMPLATE = [=[
---
name: %{name}
description: |
    %{description}
homepage: %{homepage}
languages: []
categories: []
licenses:
    - %{license}

source:
    # renovate:datasource=%{datasource}
    id: pkg:github/%{namespace}/%{name}@%{version}
    archive:
        type: zipball

opt:
    pack/mason/opt/%{name}/: "./"
]=]

local function json_decode(str)
    return vim.json.decode(str, {
        luanil = {
            object = true,
            array = true,
        }
    })
end

local gh = vim.fn.exepath"gh"

return {
    ---@async
    ---@param plugin_name string
    ["github-refs"] = function(plugin_name)
        return Result.try(function(try)
            -- local repo =
            --     try(fetch(("https://api.github.com/repos/%s"):format(plugin_name)):map_catching(json_decode))
            local repo = try(spawn[gh] { "api", ("repos/%s"):format(plugin_name) }:map(_.prop "stdout"):map_catching(json_decode))
            local default_branch_url = repo.branches_url:gsub("{/branch}", "/" .. repo.default_branch)
            local default_branch = try(spawn[gh] {"api", default_branch_url }:map(_.prop "stdout"):map_catching(json_decode))

            serializer.write(repo.name, PACKAGE_TEMPLATE) {
                namespace = repo.owner.login,
                name = repo.name,
                description = repo.description or plugin_name,
                homepage = repo.html_url,
                license = vim.tbl_get(repo, "license", "spdx_id") or "proprietary",
                version = default_branch.commit.sha,
                datasource = "github-refs",
            }
        end)
    end,
    ---@async
    ---@param plugin_name string
    ["github-tags"] = function(plugin_name)
        return Result.try(function(try)
            -- local repo =
            --     try(fetch(("https://api.github.com/repos/%s"):format(plugin_name)):map_catching(json_decode))
            local repo = try(spawn[gh] { "api", ("repos/%s"):format(plugin_name) }:map(_.prop "stdout"):map_catching(json_decode))
            local latest_tag = try(registry_api.github.tags.latest({ repo = plugin_name }))

            serializer.write(repo.name, PACKAGE_TEMPLATE) {
                namespace = repo.owner.login,
                name = repo.name,
                description = repo.description or plugin_name,
                homepage = repo.html_url,
                license = vim.tbl_get(repo, "license", "spdx_id") or "proprietary",
                version = latest_tag.tag,
                datasource = "github-tags",
            }
        end)
    end,
}
