local semver = require("crates.semver")

local function match(version, requirement)
    local v = semver.parse_version(version)
    local r = semver.parse_requirement(requirement)
    return semver.matches_requirement(v, r)
end

local function assert_match(version, requirement)
    if not match(version, requirement) then
        error(string.format("version should match `%s` `%s`", version , requirement), 2)
    end
end

local function assert_error(version, requirement)
    if match(version, requirement) then
        error(string.format("version shouldn't match `%s` `%s`", version , requirement), 2)
    end
end

describe("match requirements", function()
    it("caret", function()
        assert_match("2.0.3", "^2.0.3")
        assert_match("2.0.5", "^2.0.3")
        assert_match("2.0.5", "^2.0")
        assert_match("2.0.5", "^2")
        assert_match("0.7.5", "^0.7.3")
        assert_match("0.7.3", "^0.7.3")
        assert_match("0.7.5", "^0.7")
        assert_match("0.7.5", "^0")
        assert_match("0.0.3", "^0.0.3")
        assert_match("0.0.5", "^0.0")
        assert_match("0.0.5", "^0.0")
        assert_match("0.0.5", "^0")
        assert_match("0.9.5", "^0")
        assert_match("1.2.0-rc.0", "^1.2.0-rc.0")
        assert_match("1.2.0-rc.2", "^1.2.0-rc.0")
        assert_match("1.2.0", "^1.2.0-rc.0")

        assert_error("2.0.2", "^2.0.3")
        assert_error("3.0.0", "^2.0.3")
        assert_error("2.0.5", "^2.1")
        assert_error("3.0.0", "^2.1")
        assert_error("1.0.5", "^2")
        assert_error("3.0.1", "^2")
        assert_error("0.7.2", "^0.7.3")
        assert_error("0.8.0", "^0.7")
        assert_error("1.0.0", "^0")
        assert_error("0.0.3", "^0.0.2")
        assert_error("0.0.3", "^0.0.4")
        assert_error("0.1.0", "^0.0")
        assert_error("1.0.0", "^0")
        assert_error("1.2.0-rc.0", "^1.2.0-rc.2")
        assert_error("1.2.0-rc.6", "^1.2.0")
    end)

    it("tilde", function()
        assert_match("2.0.5", "~2.0.3")
        assert_match("2.0.5", "~2.0")
        assert_match("2.0.0", "~2.0")
        assert_match("2.0.5", "~2")

        assert_error("2.0.5", "~2.0.6")
        assert_error("2.1.0", "~2.0.6")
        assert_error("2.0.5", "~2.1")
        assert_error("4.0.0", "~3")
        assert_error("2.4.8", "~3")
    end)

    it("wildcard", function()
        assert_match("2.0.5", "2.0.*")
        assert_match("2.0.5", "2.*")
        assert_match("2.0.5", "*")

        assert_error("2.1.3", "2.3.*")
        assert_error("2.4.3", "2.3.*")
        assert_error("1.0.5", "2.*")
        assert_error("3.0.5", "2.*")
    end)

    it("equals", function()
        assert_match("2.0.5", "=2.0.5")
        assert_match("2.0.5", "=2.0")
        assert_match("2.0.5", "=2")
        assert_match("2.0.5-beta.6", "=2.0.5-beta.6")

        assert_error("2.0.5", "=2.0.6")
        assert_error("2.0.5", "=2.0.3")
        assert_error("2.0.5", "=2.1.5")
        assert_error("2.0.5", "=2.1")
        assert_error("2.0.5", "=3")
        assert_error("2.0.5", "=1")
        assert_error("2.0.5-beta.6", "=2.0.5")
        assert_error("2.0.5-beta.6", "=2.0")
        assert_error("2.0.5-beta.6", "=2")
    end)

    it("less than", function()
        assert_match("2.0.5", "<2.0.6")
        assert_match("2.0.5", "<2.1")
        assert_match("2.0.5", "<3")
        assert_match("2.0.0-pre.0", "<2.0.0")

        assert_error("2.1.5", "<2.1.5")
        assert_error("2.1.5", "<2.1.4")
        assert_error("2.1.5", "<2.0.6")
        assert_error("2.1.5", "<2.1")
        assert_error("2.1.5", "<2")
        assert_error("2.0.1-pre.0", "<2.0.0")
    end)

    it("less than or equal", function()
        assert_match("2.1.5", "<=2.1.6")
        assert_match("2.1.5", "<=2.1.5")
        assert_match("2.1.5", "<=2.1")
        assert_match("2.1.5", "<=2.1")
        assert_match("2.1.5", "<=3")
        assert_match("2.1.5", "<=2")
        assert_match("3.0.0-beta.3", "<=3")
        assert_match("3.1.1-beta.3", "<=3.1")

        assert_error("2.1.5", "<=2.1.4")
        assert_error("2.1.5", "<=2.0.6")
        assert_error("2.1.5", "<=2.0")
        assert_error("2.1.5", "<=1")
        assert_error("3.1.1-beta.3", "<=3.0")
    end)

    it("greater than", function()
        assert_match("2.4.5", ">2.4.3")
        assert_match("2.4.5", ">2.3")
        assert_match("2.4.5", ">1")
        assert_match("2.0.0-beta.3", ">1.9.9")

        assert_error("2.1.5", ">2.1.5")
        assert_error("2.1.5", ">2.1.6")
        assert_error("2.1.5", ">2.2.0")
        assert_error("2.1.5", ">2.1")
        assert_error("2.1.5", ">2")
        assert_error("2.0.0-beta.3", ">2")
    end)

    it("greater than or equal", function()
        assert_match("2.1.5", ">=2.0.6")
        assert_match("2.1.5", ">=2.1.5")
        assert_match("2.1.5", ">=2.1")
        assert_match("2.1.5", ">=2.1")
        assert_match("2.1.5", ">=2")
        assert_match("2.0.1-beta.3", ">=2.0.0")

        assert_error("2.1.5", ">=2.1.6")
        assert_error("2.1.5", ">=2.3.3")
        assert_error("2.1.5", ">=2.2")
        assert_error("2.1.5", ">=3")
        assert_error("2.0.0-beta.3", ">=2")
    end)
end)
