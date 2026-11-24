Name:           video-studio-br
Version:        1.0.0
Release:        1%{?dist}
Summary:        Editor de vídeo livre baseado no Shotcut

License:        GPL-3.0-only
URL:            https://github.com/ronney13/studiocut
Source0:        video-studio-br-linux-x86_64.tar.xz

BuildArch:      x86_64
Requires:       qt6-qtbase
Requires:       qt6-qtdeclarative
Requires:       mlt
Requires:       ffmpeg-libs

%description
Vídeo Studio BR é um editor de vídeo multiplataforma, livre e de código aberto,
derivado do Shotcut. Interface em português do Brasil e tema dark moderno.

%prep
%setup -q -n video-studio-br

%install
mkdir -p %{buildroot}/opt/video-studio-br
cp -a . %{buildroot}/opt/video-studio-br/
mkdir -p %{buildroot}%{_bindir}
ln -s /opt/video-studio-br/video-studio-br %{buildroot}%{_bindir}/video-studio-br
install -Dm644 packaging/linux/video-studio-br.desktop \
  %{buildroot}%{_datadir}/applications/org.videostudiobr.VideoStudioBR.desktop
install -Dm644 icons/studiocut-logo-64.svg \
  %{buildroot}%{_datadir}/icons/hicolor/scalable/apps/org.videostudiobr.VideoStudioBR.svg

%files
/opt/video-studio-br
%{_bindir}/video-studio-br
%{_datadir}/applications/org.videostudiobr.VideoStudioBR.desktop
%{_datadir}/icons/hicolor/scalable/apps/org.videostudiobr.VideoStudioBR.svg

%changelog
* Tue Nov 24 2026 Vídeo Studio BR <ronney13@users.noreply.github.com> - 1.0.0-1
- Primeiro pacote RPM do fork.
