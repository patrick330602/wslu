%define packager       Jinming Wu, Patrick <me@patrickwu.space>
Summary: Windows 10 Linux Subsystem Utilities
Name: wslu
Version: BUILDVERPLACEHOLDER
Release: RELVERPLACEHOLDER
Source: wslu-BUILDVERPLACEHOLDER.tar.gz
BuildArch: noarch
Requires(pre,preun): desktop-file-utils
BuildRequires: make gzip
Requires: bc ImageMagick
Requires(post): %{_sbindir}/update-alternatives %{_bindir}/update-desktop-database %{_bindir}/desktop-file-install
Requires(postun): %{_sbindir}/update-alternatives %{_bindir}/update-desktop-database
BuildRoot: %{_tmppath}/%{name}-%{version}-build
URL: https://github.com/wslutilities/wslu/
License: GPL-3.0-or-later

%description
This is a collection of utilities for Windows 10 Linux Subsystem, such as converting WSL path to Windows path or creating your favorite linux app shortcuts on Windows 10 Desktop. Requires Windows 10 Creators Update and higher.

%prep
%setup -q

%build
make

%install
# for os <= 7
mkdir -p %{?buildroot}/usr/share/man/man1/
mkdir -p %{?buildroot}/usr/share/man/man7/
mkdir -p %{?buildroot}/usr/share/wslu/
mkdir -p %{?buildroot}/usr/bin/
# normal part
make PREFIX=/usr DESTDIR=%{?buildroot} install
ln -sf /usr/bin/wslview %{?buildroot}/usr/bin/wview
ln -sf /usr/bin/wslview %{?buildroot}/usr/bin/wslstart
ln -sf /usr/bin/wslview %{?buildroot}/usr/bin/wstart
ln -sf /usr/share/man/man1/wslview.1.gz %{?buildroot}/usr/share/man/man1/wview.1.gz
ln -sf /usr/share/man/man1/wslview.1.gz %{?buildroot}/usr/share/man/man1/wslstart.1.gz
ln -sf /usr/share/man/man1/wslview.1.gz %{?buildroot}/usr/share/man/man1/wstart.1.gz

%post
%{_sbindir}/update-alternatives --install %{_bindir}/www-browser www-browser %{_bindir}/wslview 1
%{_sbindir}/update-alternatives --install %{_bindir}/x-www-browser x-www-browser %{_bindir}/wslview 1
date +"%s" | tee /usr/share/wslu/updated_time >/dev/null
desktop-file-install --dir=/usr/share/applications /usr/share/wslu/wslview.desktop
update-desktop-database

%postun
if [ -f /usr/share/wslu/updated_time ]; then
    rm /usr/share/wslu/updated_time
fi
if [ -f /usr/share/applications/wslview.desktop ]; then
    rm /usr/share/applications/wslview.desktop
    update-desktop-database
fi
%{_sbindir}/update-alternatives --remove www-browser %{_bindir}/wslview
%{_sbindir}/update-alternatives --remove x-www-browser %{_bindir}/wslview

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
%{_bindir}/wslusc
%{_bindir}/wslfetch
%{_bindir}/wslsys
%{_bindir}/wslupath
%{_bindir}/wslview
%{_bindir}/wview
%{_bindir}/wstart
%{_bindir}/wslstart
%{_bindir}/wslact
%{_bindir}/wslvar
%{_bindir}/wslgsu
/usr/share/wslu/
%doc /usr/share/man/

%changelog
* DATETIMEPLACEHOLDER Jinming Wu, Patrick <me@patrickwu.space> - BUILDVERPLACEHOLDER-RELVERPLACEHOLDER
- Please check https://github.com/wslutilities/wslu/releases/latest for changelog

