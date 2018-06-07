# Feature Toggles

Some features can be toggled on an off on a group-by-group basis. To inspect and change the, log into a rails console and then...

## Discovering Toggles

```ruby
FeatureToggle::FEATURES
```

## Inspecting All Toggles for a Group

```ruby
Group.find(3).feature_toggles
```

## Inspecting One Toggle for a Group

```ruby
Group.find(3).feature_on?(:email_google_group)
```

## Changing One Toggle for a Group

```ruby
Group.find(3).toggle_feature_on(:email_google_group)
Group.find(3).toggle_feature_off(:email_google_group)
```

## Generate feature toggle with Rake task

```shell
$ rake feature_toggles:create[feature_name]
```

# Static Feature Toggles

TK-TODO