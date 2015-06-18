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
sub add_main_column_span { return 8; }
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
sub custom_snippet_add_position
{
    return "right";
}
sub custom_add_snippet
{
    my $self = shift;
    if(ref($self))
    {
        my @languages;
        if(config->{Strehler}->{languages})
        {
            @languages = @{config->{Strehler}->{languages}};
        }
        else
        {
            @languages = ('en');
        }
        my $explain = q{
        <p>Link to RSS, you can copy them from here and use them on the frontend</p>
        <p>If you want to click them, remember that they'll work only if the RSS Channel is published.</p>
        };
        my $explain_default = q{
            <p>Default RSS is the RSS in the default language</p>
        };
        my $default_language =  config->{Strehler}->{default_language};
        my $default_link = "/rss/" . $self->get_attr_multilang('slug',  $default_language) . ".xml";
        my $out = "<h3>Links to RSS</h3>" . $explain .
                  "<h5>Default</h5>" . $explain_default .
                  "<ul><li><a href=\"$default_link\">$default_link</a></li></ul>" .
                  "<h5>By language</h5><ul>";
        foreach my $lang (@languages)
        {
            if($self->get_attr_multilang('slug',  $lang))
            {
                my $link = "/rss/$lang/" . $self->get_attr_multilang('slug',  $lang) . ".xml";
                $out .= "<li>$lang: <a href=\"$link\">$link</a></li>"
            }
        }
        $out .= "</ul>";
        return $out; 
    }
    else
    {
        return undef;
    }
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



