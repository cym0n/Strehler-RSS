package Strehler::Element::RSS::RSSChannel;

use strict;
use Cwd 'abs_path';
use Moo;
use Dancer2 0.154000;
use Strehler::Helpers;
use File::Copy;

extends 'Strehler::Element';
with 'Strehler::Element::Role::Slugged';
with 'Strehler::Element::Role::Maintainer';

my $module_file_path = __FILE__;
my $root_path = abs_path($module_file_path);
$root_path =~ s/RSSChannel\.pm//;
my $form_path = $root_path . "../../forms";
my $views_path = $root_path . "../../views";

sub metaclass_data 
{
    my $self = shift;
    my $param = shift;
    my %element_conf = ( item_type => 'rsschannel',
                         ORMObj => 'Rsschannel',
                         category_accessor => 'rsschannels',
                         multilang_children => 'rsschannel_headers' );
    return $element_conf{$param};
}
sub form { return "$form_path/RSS/rsschannel.yml" }
sub multilang_form { return "$form_path/RSS/rsschannel_multilang.yml" }
sub categorized { return 1; }
sub publishable  { return 1; }
sub add_main_column_span { return 9; }
sub entity_js { return '/strehler/js/rsschannel.js'; }

sub main_title
{
    my $self = shift;
    my @contents = $self->row->rsschannel_headers->search({ language => config->{Strehler}->{default_language} });
    if($contents[0])
    {
        return $contents[0]->title;
    }
    else
    {
        #Should not be possible
        return "*** no title ***";
    }

}
sub fields_list
{
    my $self = shift;
    my @fields = ( { 'id' => 'id',
                     'label' => 'ID',
                     'ordinable' => 1 },
                   { 'id' => 'rsschannel_headers.title',
                     'label' => 'Title',
                     'ordinable' => 1 },
                   { 'id' => 'category',
                       'label' => 'Category',
                       'ordinable' => 0 },
                   { 'id' => 'entity_type',
                       'label' => 'Entity',
                       'ordinable' => 1 },
                   { 'id' => 'published',
                     'label' => 'Status',
                     'ordinable' => 1 }
               );
    return \@fields;
}
sub custom_list_template
{
    return $views_path . "/admin/rss/rss_list_block.tt";
}

sub install
{
    my $self = shift;
    my $dbh = shift;
    $self->deploy_entity_on_db($dbh, ["Strehler::Schema::RSS::Result::Rsschannel", "Strehler::Schema::RSS::Result::RsschannelHeader"]);
    my $package_root = __FILE__;
    $package_root =~ s/RSSChannel\.pm$//;
    my $statics = $package_root . "../../public";
    my $configured_public_directory = Strehler::Helpers::public_directory();
    copy($statics . "/strehler/js/rsschannel.js", $configured_public_directory . "/strehler/js") || print "Failing copying from $statics" . "/js/rsschannel.js to " . $configured_public_directory . "/strehler/js\nError: " . $! . "\n";
    return "RSS Channel entity available!\n\nJavascript resources copied under public directory!\n\nDeploy of database tables completed\n\nCheck above for errors\n\nRun strehler schemadump to update your model\n\n";
}



