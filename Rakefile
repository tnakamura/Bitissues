# coding: utf-8
require "date"

namespace :intra do
  desc "Set up project for intra net."
  task :setup do
    sh "git init ."
    sh "git add ."
    sh 'git commit -m "Initial commit"'
    sh "git checkout -b development"
  end

  desc "Merge development branch and generate patch ."
  task :patch do
    sh "git checkout master"
    sh "git merge --squash development"
    sh 'git commit -m "Merge development"'
    sh "git branch -D development"
    sh "git diff HEAD~ --no-prefix > bitissues_#{Date.today}.patch"
  end
end
