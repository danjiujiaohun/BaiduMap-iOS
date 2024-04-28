# 依赖库文件仓库链接
source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '12.0'
use_frameworks!

target 'BaiduMap' do
    pod 'SnapKit'
    pod 'JXBanner'
    pod 'Alamofire', '~> 5.4.4'
    pod 'SVProgressHUD'
    pod 'SDWebImage/MapKit'
    pod 'LookinServer'
    pod 'TZImagePickerController'
    # pod 'Kingfisher', '4.10.1'
    # pod 'HandyJSON', '~> 4.2.0-beta1'
    # pod 'RxSwift',    '~> 4.2.0'
    # pod 'RxCocoa',    '~> 4.2.0'
    pod 'IQKeyboardManager'
    pod 'YYText'
    pod 'JXPagingView'
    pod 'JXSegmentedView'
    pod 'MJRefresh'
    pod 'HandyJSON'
    pod 'RTRootNavigationController'
    pod 'BaiduMapKit'


#   OC混编第三方库
    # pod 'MJRefresh'
    # pod 'SVProgressHUD'
    # pod 'DZNEmptyDataSet'
    # pod 'RTRootNavigationController'
    # pod 'UITextView+Placeholder', '~> 1.2'
    # pod 'ActionSheetPicker-3.0', '~> 2.3.0'
    # pod 'KLCPopup', '~> 1.0'
    # pod 'TZImagePickerController', '1.8.1'
    # pod 'UITableView+FDTemplateLayoutCell', '~>1.6'
    # pod 'YYModel', '~>1.0.4'
end

post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
       end
    end
  end
end
