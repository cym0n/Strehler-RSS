use utf8;
package Strehler::Schema::RSS::Result::RsschannelHeader;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Strehler::Schema::RSS::Result::RsschannelHeader

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<RSSCHANNEL_HEADERS>

=cut

__PACKAGE__->table("RSSCHANNEL_HEADERS");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 rsschannel

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 title

  data_type: 'varchar'
  is_nullable: 1
  size: 120

=head2 description

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=head2 slug

  data_type: 'varchar'
  is_nullable: 1
  size: 120

=head2 language

  data_type: 'varchar'
  is_nullable: 1
  size: 2

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "rsschannel",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "title",
  { data_type => "varchar", is_nullable => 1, size => 120 },
  "description",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "slug",
  { data_type => "varchar", is_nullable => 1, size => 120 },
  "language",
  { data_type => "varchar", is_nullable => 1, size => 2 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 rsschannel

Type: belongs_to

Related object: L<Strehler::Schema::RSS::Result::Rsschannel>

=cut

__PACKAGE__->belongs_to(
  "rsschannel",
  "Strehler::Schema::RSS::Result::Rsschannel",
  { id => "rsschannel" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07037 @ 2015-06-10 00:57:59
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Gq4nlOw29xMLbAimWr4vCA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
