.PHONY: setup
setup:
	$(MAKE) install-bundler
	$(MAKE) add-missing-files-if-need

.PHONY: install-bundler
install-bundler:
	bundle config path vendor/bundle
	bundle install --without=documentation --jobs 4 --retry 3

.PHONY: update-bundler
update-bundler:
	bundle config path vendor/bundle
	bundle update --jobs 4 --retry 3

.PHONY: add-missing-files-if-need
add-missing-files-if-need:
	-@cp -n ./fusen/Presentation/Resource/GoogleService-Info-dummy.plist ./fusen/Presentation/Resource/GoogleService-Info-development.plist
	-@cp -n ./fusen/Presentation/Resource/GoogleService-Info-dummy.plist ./fusen/Presentation/Resource/GoogleService-Info-staging.plist
	-@cp -n ./fusen/Presentation/Resource/GoogleService-Info-dummy.plist ./fusen/Presentation/Resource/GoogleService-Info-production.plist
	-@mv ./App/App/Sources/Data/Resource/APIKey-dummy ./App/App/Sources/Data/Resource/APIKey-dummy.swift

.PHONY: test
test:
	bundle exec fastlane test

.PHONY: clean
clean:
	@rm -rf ./vendor/bundle
	@xcodebuild clean -alltargets