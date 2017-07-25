@echo off
del /F /Q *.gem
cmd /c "gem uninstall cutedriver_driver -a -x -I"
cmd /c "gem build cutedriver-driver.gemspec"
cmd /c "gem install cutedriver_driver*.gem --LOCAL --no-ri --no-rdoc"
