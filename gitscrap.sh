curl -u jusrob -s https://api.github.com/orgs/[ORG]/repos?per_page=500 | ruby -rubygems -e 'require "json"; JSON.load(STDIN.read).each { |repo| %x[git clone #{repo["clone_url"]} ]}'
