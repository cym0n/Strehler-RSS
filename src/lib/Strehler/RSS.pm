package Strehler::RSS;

# ABSTRACT: RSS management using Strehler

use strict;
use Dancer2 0.160000;
use Strehler::Element::RSS::RSSChannel;
use Strehler::Helpers;
use XML::Feed;
use XML::Feed::Entry;

prefix '/rss';

get '/:lang/:slug' => sub
{
    my $language = params->{lang};
    my $slug = params->{slug};
    $slug =~ s/\.xml$//;
    my $rss = Strehler::Element::RSS::RSSChannel->get_by_slug($slug, $language);
    my %rss_data = $rss->get_ext_data();
    my $entity = Strehler::Helpers::class_from_entity($rss_data{'entity_type'});
    my $query;
    $query->{'order'} = 'desc';
    $query->{'order_by'} = $rss->get_attr("order_by");
    $query->{'entries_per_page'} = 6;
    $query->{'language'} = $language;
    $query->{'published'} = 1;
    $query->{'ext'} = 1;
    if($rss->get_attr("deep") && $rss->get_attr("deep") == 1)
    {
        $query->{'ancestor'} = $rss->get_attr("category", 1);
    }
    else
    {
        $query->{'category'} = $rss->get_attr("category");
    }
    my $elements = $entity->get_list($query);
    my $rss_items = [];
    my $link_template = $rss->get_attr('link_template');
    my $feed = XML::Feed->new('RSS', version => '2.0');
    $feed->title($rss->get_attr_multilang('title', $language)); 
    $feed->description($rss->get_attr_multilang('description', $language)); 
    $feed->link($rss->get_attr('link')); 
    $feed->language($language); 
    $feed->generator("Strehler::RSS " . $Strehler::RSS::VERSION); 
    foreach my $e (@{$elements->{'to_view'}})
    {
        my $item = XML::Feed::Entry->new('RSS', version => '2.0');
        $item->title($e->{$rss->get_attr('title_field')});
        $item->content($e->{$rss->get_attr('description_field')});
        
        my $link_value = $e->{$rss->get_attr('link_field')};
        my $link = $link_template;
        $link =~ s/%%/$link_value/;
        $link =  $link;
        $item->link($link);
        $feed->add_entry($item);

    }

    content_type('application/rss+xml');
    return $feed->as_xml;
};

1;
