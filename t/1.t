use strict;
use warnings;
use Test::More tests => 19;

BEGIN { use_ok( 'Torque::Log' ); }
{
    open my $fh, '<', 't/test.log' || die "couldn't open test file (test.log)\n";
    my $t = Torque::Log->new;
    isa_ok($t, 'Torque::Log');

    my ($tn) = $t->parse($fh);
    isa_ok($tn, 'Torque::Log');

    # These should be the same object
    ok($tn == $t);

    my (@entries) = $t->get_entries;
    ok(@entries == 1);

    my ($entry) = @entries;
    isa_ok($entry, 'Torque::Log::Entry');
    ok($entry->date->epoch == 1375861561);
    ok($entry->type eq 'E');
    ok($entry->id eq '67130.maui');
    ok($entry->info->{user} eq 'foo');
    ok($entry->info->{'resources_used.vmem'} eq '8734452kb');
    ok($entry->info->{'resources_used.walltime'} eq '17:06:15');
}

{
    open my $fh, '<', 't/test.log' || die "couldn't open test file (test.log)\n";
    my $line = <$fh>;
    my ($entry) = Torque::Log->new->parse_line($line);
    isa_ok($entry, 'Torque::Log::Entry');

    ok($entry->date->epoch == 1375861561);
    ok($entry->type eq 'E');
    ok($entry->id eq '67130.maui');
    ok($entry->info->{user} eq 'foo');
    ok($entry->info->{'resources_used.vmem'} eq '8734452kb');
    ok($entry->info->{'resources_used.walltime'} eq '17:06:15');
}
