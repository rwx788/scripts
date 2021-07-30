#!/bin/sh

print_help()
{
  echo "Usage: uninstall-vs-mac.sh [options]"
  echo "    -vs,  --visual-studio   #remove VisualStudio for Mac and Xamarin SDKs"
  echo "    -xjb, --xamarin-jb      #remove all JetBrains Xamarin SDKs and tools"
  echo "    -xvs, --xamarin-vs      #remove all Visual Studio Xamarin SDKs and tools"
}

remove_vs()
{
  remove_xamarin_vs

  # Uninstall Visual Studio for Mac
  echo "Uninstalling Visual Studio for Mac..."

  sudo rm -rf "/Applications/Visual Studio.app"
  rm -rf ~/Library/Caches/VisualStudio
  rm -rf ~/Library/Preferences/VisualStudio
  rm -rf ~/Library/Preferences/Visual\ Studio
  rm -rf ~/Library/Logs/VisualStudio
  rm -rf ~/Library/VisualStudio
  rm -rf ~/Library/Preferences/Xamarin/
  rm -rf ~/Library/Application\ Support/VisualStudio
  rm -rf ~/Library/Application\ Support/VisualStudio/7.0/LocalInstall/Addins/

  # Uninstall the Visual Studio for Mac Installer
  echo "Uninstalling the Visual Studio for Mac Installer..."

  rm -rf ~/Library/Caches/XamarinInstaller/
  rm -rf ~/Library/Caches/VisualStudioInstaller/
  rm -rf ~/Library/Logs/XamarinInstaller/
  rm -rf ~/Library/Logs/VisualStudioInstaller/
}

remove_xamarin_jb(){
  # Uninstall Xamarin.Android, Xamarin.iOS, Xamarin.Mac
  echo "Uninstalling Jetbrains Xamarin Android, iOS and Mac JB SDKs..."

  sudo rm -rf /Library/Frameworks/Mono.framework/External/xbuild/Xamarin
  sudo rm -rf /Library/Frameworks/Mono.framework/External/xbuild-frameworks
  sudo rm -rf /Library/Frameworks/Xamarin.Android.framework
  sudo rm -rf /Library/Frameworks/Xamarin.iOS.framework
  sudo rm -rf /Library/Frameworks/Xamarin.Mac.framework

  sudo pkgutil --forget com.jetbrains.xamarin.android.sdk
  sudo pkgutil --forget com.jetbrains.xamarin.macios.sdk
}

remove_xamarin_vs()
{
  # Uninstall Xamarin.Android, Xamarin.iOS,
  echo "Uninstalling Jetbrains Xamarin Android, iOS and Mac VS SDKs..."
  remove_xamarin_android
  remove_xamarin_ios
  remove_xamarin_mac
  # Uninstall the Xamarin Profiler
  echo "Uninstalling the Xamarin Profiler..."

  sudo rm -rf "/Applications/Xamarin Profiler.app"
  sudo pkgutil --forget com.xamarin.profiler

  # Uninstall Workbooks and Inspector
  echo "Uninstalling Workbooks and Inspector..."

  if [ -f "/Library/Frameworks/Xamarin.Interactive.framework/Versions/Current/uninstall" ]; then
      sudo /Library/Frameworks/Xamarin.Interactive.framework/Versions/Current/uninstall
  fi
}

remove_xamarin_android()
{
  # Uninstall Xamarin.Android
  echo "Uninstalling Xamarin.Android..."

  sudo rm -rf /Developer/MonoDroid
  rm -rf ~/Library/MonoAndroid
  sudo pkgutil --forget com.xamarin.android.pkg
  sudo rm -rf /Library/Frameworks/Xamarin.Android.framework
}

remove_xamarin_ios()
{
  # Uninstall Xamarin.iOS
  echo "Uninstalling Xamarin.iOS..."

  rm -rf ~/Library/MonoTouch
  sudo rm -rf /Library/Frameworks/Xamarin.iOS.framework
  sudo rm -rf /Developer/MonoTouch
  sudo pkgutil --forget com.xamarin.monotouch.pkg
  sudo pkgutil --forget com.xamarin.xamarin-ios-build-host.pkg
}

remove_xamarin_mac()
{
  # Uninstall Xamarin.Mac
  echo "Uninstalling Xamarin.Mac..."

  sudo rm -rf /Library/Frameworks/Xamarin.Mac.framework
  rm -rf ~/Library/Xamarin.Mac
}

if [ $# -eq 0 ]; then
    print_help
    exit 1
fi

for key in "$@"; do
  case $key in
    -vs|--visual-studio)
      remove_vs
      ;;
    -xjb|--xamarin-jb)
      remove_xamarin_jb
      ;;
    -xvs|--xamarin-vs)
      remove_xamarin_vs
      ;;
    --help)
      print_help
      ;;
    *)    # unknown option
      print_help
      ;;
  esac
done
