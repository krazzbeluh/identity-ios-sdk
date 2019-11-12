# Guide for publication

1. Create a branch with the name of the version `x.x.x`

2. Change the version in `version.rb` file
```ruby
$VERSION = 'x.x.x'
```

3. Submit and merge the pull request

4. Add git tag `x.x.x` to the merge commit
```sh
git tag x.x.x
```

5. Push the tag
```sh
git push origin x.x.x
```

6. The CI will automatically publish this new version

7. Finally, draft a new release in the [Github releases tab](https://github.com/ReachFive/identity-ios-sdk/releases) (copy & paste the changelog in the release's description).
