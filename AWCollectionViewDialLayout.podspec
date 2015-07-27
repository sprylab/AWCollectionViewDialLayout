Pod::Spec.new do |s|
  s.name             = "AWCollectionViewDialLayout"
  s.version          = "0.1.0"
  s.summary          = "UICollectionViewLayout for displaying cells in a semi-circle with a nice fish eye effect."
  s.description      = <<-DESC
                       Very handy for quickly browsing items with your left thumb without having some of the content hidden behind your finger while you scroll.
                       DESC
  s.homepage         = "https://github.com/sprylab/AWCollectionViewDialLayout"
  s.license          = 'MIT'
  s.author           = { "Antoine Wette", "Claus Weymann" => "claus.weymann@sprylab.com" }
  s.source           = { :git => "https://github.com/sprylab/AWCollectionViewDialLayout.git", :tag => s.version.to_s }


  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'AWCollectionViewDialLayout' => ['Pod/Assets/*.png']
  }
end
