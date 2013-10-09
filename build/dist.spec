Name: perl-<% $zilla->name %>
Version: <% (my $v = $zilla->version) =~ s/^v//; $v %>
Release: 1

Summary: <% $zilla->abstract %>
License: GPL+ or Artistic
Group: Applications/CPAN
BuildArch: noarch
URL: <% $zilla->license->url %>
Vendor: <% $zilla->license->holder %>
Source: <% $archive %>

BuildRequires: perl(ExtUtils::MakeMaker) perl(Test::More) perl(Moose) perl(DateTime::Format::Strptime)
BuildRequires: perl(namespace::autoclean) perl(Moose) perl(DateTime::Format::Strptime)

BuildRoot: %{_tmppath}/%{name}-%{version}-BUILD

%description
<% $zilla->abstract %>

%prep
%setup -qn <% $zilla->name %>-%version

%build
perl Makefile.PL
make test

%install
if [ "%{buildroot}" != "/" ] ; then
    rm -rf %{buildroot}
fi
make install DESTDIR=%{buildroot}
rm -rf %{buildroot}/%{_libdir}
find %{buildroot} -name parse_logs.pl -exec rm -f {} \;
find %{buildroot} | sed -e 's#%{buildroot}##' > %{_tmppath}/filelist

%clean
if [ "%{buildroot}" != "/" ] ; then
    rm -rf %{buildroot}
fi

%files -f %{_tmppath}/filelist
%defattr(-,root,root)
