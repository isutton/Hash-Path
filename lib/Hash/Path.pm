package Hash::Path;

use warnings;
use strict;

our $VERSION = '0.01';

sub get {
    my ( $class, $data_ref, $k, @path ) = @_;

    # at this point, $data_ref may or not be a hash
    # reference. we must ensure that if $k is not defined,
    # we return that data without trying to travessing it.
    return $data_ref if not defined $k;

    # it is pretty self-explained.
    return Hash::Path->get( $data_ref->{$k}, @path )
      if (  defined $k
        and ref($data_ref)         eq 'HASH'
        and ref( $data_ref->{$k} ) eq 'HASH'
        and exists $data_ref->{$k} );

    return $data_ref->{$k}
      if defined $k
      and ref($data_ref) eq 'HASH'
      and exists $data_ref->{$k};

    # what about this one?
    return undef;
}

1;

=pod

=head1 NAME

Hash::Path - A simple way to return a path of HoH

=head1 VERSION

0.01

=head1 SYNOPSIS

	 use Hash::Path;

	 my $hash_ref = {
	     key1 => {
	         key2 => {
	             key3 => 'value',
	         },
	     },
	 };

	 my $wanted = Hash::Path->( $hash_ref, qw{key1 key2 key3} );

	 # $wanted contains 'value'

=head1 DESCRIPTION

This module was written as proof of concept about how to find data inside a hash of hashes (HoH) with
unknown structure. You can think that as hierarchical data like LDAP does, so our C<path> could be the
exactly the same as LDAP's C<dn>, but a bit simpler because we (at least at this moment, who knows) don't
want to deal with that.

This is a perfect companion for traversing L<YAML>:

	use Hash::Path;
	use YAML;

	my ($hash_ref) = Load(<<'EOF');
	---
	name: john
	permissions:
	  some-module:
	    - read
	    - write
	    - execute
	  another-module:
	    - read
	EOF
	my $permissions = Hash::Path->get($hash_ref, qw(permissions some-module));

	# $permissions contains [ 'read', 'write', 'execute' ]

=head1 API

=over 4

=item get

	$scalar = Hash::Path->get($hash_ref, @path);

This is the only available method. It traverses the hash reference using the supplied path array,
returning the value as scalar value.

=back

=head1 AUTHOR

Copyright (c) 2007, Igor Sutton Lopes "<IZUT@cpan.org>". All rights reserved.

This module is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut
