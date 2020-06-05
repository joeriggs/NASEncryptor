Name:           NAS_Encryptor
Version:        0.1
Release:        1
Summary:        NAS Encryptor
License:        GPLv3+

%description 
The NAS Encryptor is an extension of the NAS Proxy.  It provides encryption to the NAS Proxy.

%define _src_dir ${TOP_DIR}
%define _src_etc_dir %{_src_dir}/etc
%define _src_lib_dir %{_src_dir}/lib

%define _dst_dir /usr/local
%define _dst_etc_dir /etc
%define _dst_lib_dir %{_dst_dir}/lib

%define _do_nas_encryptor %{?DO_NAS_ENCRYPTOR:1}

%build

%install

mkdir -p ${RPM_BUILD_ROOT}/%{_dst_lib_dir}
mkdir -p ${RPM_BUILD_ROOT}/%{_dst_etc_dir}

cp %{_src_etc_dir}/NASEncryptor.conf      ${RPM_BUILD_ROOT}/%{_dst_etc_dir}/NASEncryptor.conf

cp %{_src_lib_dir}/encryptorUtils         ${RPM_BUILD_ROOT}/%{_dst_lib_dir}/encryptorUtils

%post

%preun

%files
%defattr(-,root,root)

%attr(0644,root,root) %{_dst_etc_dir}
%attr(0755,root,root) %{_dst_lib_dir} 
