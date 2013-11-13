# Hook Points

Dalli first has to be hooked:

```ruby
Dalli::Server.send(:include, Dalli::RemoteBenchmarkable)
```

Then the collector thread needs to be spun off:

```ruby
Thread.start { Dalli::StatsReporter.new.run! }
```

And that's it!
