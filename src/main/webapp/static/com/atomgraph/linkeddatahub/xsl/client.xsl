<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
    <!ENTITY typeahead  "http://graphity.org/typeahead#">
    <!ENTITY lapp       "https://w3id.org/atomgraph/linkeddatahub/apps/domain#">
    <!ENTITY dydra      "https://w3id.org/atomgraph/linkeddatahub/services/dydra#">
    <!ENTITY apl        "https://w3id.org/atomgraph/linkeddatahub/domain#">
    <!ENTITY ac         "https://w3id.org/atomgraph/client#">
    <!ENTITY a          "https://w3id.org/atomgraph/core#">
    <!ENTITY rdf        "http://www.w3.org/1999/02/22-rdf-syntax-ns#">
    <!ENTITY rdfs       "http://www.w3.org/2000/01/rdf-schema#">
    <!ENTITY xsd        "http://www.w3.org/2001/XMLSchema#">
    <!ENTITY owl        "http://www.w3.org/2002/07/owl#">
    <!ENTITY skos       "http://www.w3.org/2004/02/skos/core#">
    <!ENTITY srx        "http://www.w3.org/2005/sparql-results#">
    <!ENTITY http       "http://www.w3.org/2011/http#">
    <!ENTITY acl        "http://www.w3.org/ns/auth/acl#">
    <!ENTITY ldt        "https://www.w3.org/ns/ldt#">
    <!ENTITY dh         "https://www.w3.org/ns/ldt/document-hierarchy/domain#">
    <!ENTITY sd         "http://www.w3.org/ns/sparql-service-description#">
    <!ENTITY sp         "http://spinrdf.org/sp#">
    <!ENTITY spin       "http://spinrdf.org/spin#">
    <!ENTITY spl        "http://spinrdf.org/spl#">
    <!ENTITY dct        "http://purl.org/dc/terms/">
    <!ENTITY foaf       "http://xmlns.com/foaf/0.1/">
    <!ENTITY sioc       "http://rdfs.org/sioc/ns#">
    <!ENTITY nfo        "http://www.semanticdesktop.org/ontologies/2007/03/22/nfo#">
]>
<xsl:stylesheet version="3.0"
xmlns:xhtml="http://www.w3.org/1999/xhtml"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT"
xmlns:prop="http://saxonica.com/ns/html-property"
xmlns:style="http://saxonica.com/ns/html-style-property"
xmlns:js="http://saxonica.com/ns/globalJS"
xmlns:xs="http://www.w3.org/2001/XMLSchema"
xmlns:map="http://www.w3.org/2005/xpath-functions/map"
xmlns:json="http://www.w3.org/2005/xpath-functions"
xmlns:array="http://www.w3.org/2005/xpath-functions/array"
xmlns:saxon="http://saxon.sf.net/"
xmlns:typeahead="&typeahead;"
xmlns:a="&a;"
xmlns:ac="&ac;"
xmlns:lapp="&lapp;"
xmlns:apl="&apl;"
xmlns:rdf="&rdf;"
xmlns:rdfs="&rdfs;"
xmlns:owl="&owl;"
xmlns:acl="&acl;"
xmlns:ldt="&ldt;"
xmlns:dh="&dh;"
xmlns:srx="&srx;"
xmlns:sd="&sd;"
xmlns:sp="&sp;"
xmlns:spin="&spin;"
xmlns:spl="&spl;"
xmlns:dct="&dct;"
xmlns:foaf="&foaf;"
xmlns:sioc="&sioc;"
xmlns:skos="&skos;"
xmlns:dydra="&dydra;"
xmlns:dydra-urn="urn:dydra:"
xmlns:bs2="http://graphity.org/xsl/bootstrap/2.3.2"
exclude-result-prefixes="#all"
extension-element-prefixes="ixsl"
>

    <xsl:import href="../../../../com/atomgraph/client/xsl/group-sort-triples.xsl"/>
    <xsl:import href="../../../../com/atomgraph/client/xsl/converters/RDFXML2DataTable.xsl"/>
    <xsl:import href="../../../../com/atomgraph/client/xsl/converters/SPARQLXMLResults2DataTable.xsl"/>
    <xsl:import href="../../../../com/atomgraph/client/xsl/converters/RDFXML2SVG.xsl"/>
    <xsl:import href="../../../../com/atomgraph/client/xsl/functions.xsl"/>
    <xsl:import href="../../../../com/atomgraph/client/xsl/imports/default.xsl"/>
    <xsl:import href="../../../../com/atomgraph/client/xsl/bootstrap/2.3.2/imports/default.xsl"/>
    <xsl:import href="../../../../com/atomgraph/linkeddatahub/xsl/bootstrap/2.3.2/imports/default.xsl"/>
    <xsl:import href="../../../../com/atomgraph/client/xsl/bootstrap/2.3.2/resource.xsl"/>
    <xsl:import href="../../../../com/atomgraph/client/xsl/bootstrap/2.3.2/container.xsl"/>
    <xsl:import href="../../../../com/atomgraph/linkeddatahub/xsl/bootstrap/2.3.2/resource.xsl"/>
    <xsl:import href="../../../../com/atomgraph/linkeddatahub/xsl/bootstrap/2.3.2/container.xsl"/>
    <xsl:import href="../../../../com/atomgraph/linkeddatahub/xsl/bootstrap/2.3.2/sparql.xsl"/>
    <xsl:import href="query-transforms.xsl"/>
    <xsl:import href="typeahead.xsl"/>

    <xsl:param name="ac:contextUri" as="xs:anyURI"/>
    <xsl:param name="ldt:base" as="xs:anyURI"/>
    <xsl:param name="ldt:ontology" as="xs:anyURI"/>
    <xsl:param name="ac:lang" select="ixsl:get(ixsl:get(ixsl:page(), 'documentElement'), 'lang')" as="xs:string"/>
    <!-- this is the document URI as absolute path - hash and query string are removed -->
    <xsl:param name="ac:uri" as="xs:anyURI">
        <xsl:choose>
            <!-- override with ?uri= query param value, if any -->
            <xsl:when test="ixsl:query-params()?uri">
                <xsl:sequence select="xs:anyURI(ixsl:query-params()?uri)"/>
            </xsl:when>
            <xsl:otherwise>
                <!-- remove #hash part, if any -->
                <xsl:variable name="before-hash" select="if (contains(ixsl:get(ixsl:window(), 'location.href'), '#')) then substring-before(ixsl:get(ixsl:window(), 'location.href'), '#') else ixsl:get(ixsl:window(), 'location.href')" as="xs:string"/>
                <!-- remove ?query part, if any -->
                <xsl:sequence select="xs:anyURI(if (contains($before-hash, '?')) then substring-before($before-hash, '?') else $before-hash)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:param>
    <xsl:param name="search-container-uri" select="resolve-uri('search/', $ldt:base)" as="xs:anyURI"/>
    <xsl:param name="page-size" select="20" as="xs:integer"/>
    <xsl:param name="acl:agent" as="xs:anyURI?"/>
    <xsl:param name="acl:mode" as="xs:anyURI*"/>
    <xsl:param name="ac:forClass" select="if (ixsl:query-params()?forClass) then xs:anyURI(ixsl:query-params()?forClass) else ()" as="xs:anyURI?"/>
    <xsl:param name="ac:service" select="if (ixsl:query-params()?service) then xs:anyURI(ixsl:query-params()?service) else resolve-uri('service', $ldt:base)" as="xs:anyURI?"/>
    <xsl:param name="ac:endpoint" select="if (ixsl:query-params()?endpoint) then xs:anyURI(ixsl:query-params()?endpoint) else resolve-uri('sparql', $ldt:base)" as="xs:anyURI"/>
    <xsl:param name="ac:limit" select="if (ixsl:query-params()?limit) then xs:integer(ixsl:query-params()?limit) else $page-size" as="xs:integer"/>
    <xsl:param name="ac:offset" select="if (ixsl:query-params()?offset) then xs:integer(ixsl:query-params()?offset) else 0" as="xs:integer"/>
    <xsl:param name="ac:order-by" select="ixsl:query-params()?order-by" as="xs:string?"/>
    <xsl:param name="ac:desc" select="map:contains(ixsl:query-params(), 'desc')" as="xs:boolean?"/>
    <xsl:param name="ac:mode" select="if (ixsl:query-params()?mode) then xs:anyURI(ixsl:query-params()?mode) else xs:anyURI('&ac;ReadMode')" as="xs:anyURI?"/>
    <xsl:param name="ac:query" select="ixsl:query-params()?query" as="xs:string?"/>
    <xsl:param name="ac:container-mode" select="if (ixsl:query-params()?container-mode) then xs:anyURI(ixsl:query-params()?container-mode) else xs:anyURI('&ac;ListMode')" as="xs:anyURI?"/>
    <xsl:param name="ac:googleMapsKey" select="'AIzaSyCQ4rt3EnNCmGTpBN0qoZM1Z_jXhUnrTpQ'" as="xs:string"/>
    <xsl:param name="service-query" as="xs:string">
        CONSTRUCT 
          { 
            ?service &lt;&dct;title&gt; ?title .
            ?service &lt;&sd;endpoint&gt; ?endpoint .
            ?service &lt;&dydra;repository&gt; ?repository .
          }
        WHERE
          { GRAPH ?g
              { ?service  &lt;&dct;title&gt;  ?title
                  { ?service  &lt;&sd;endpoint&gt;  ?endpoint }
                UNION
                  { ?service  &lt;&dydra;repository&gt;  ?repository }
              }
          }
    </xsl:param>

    <xsl:key name="resources" match="*[*][@rdf:about] | *[*][@rdf:nodeID]" use="@rdf:about | @rdf:nodeID"/>
    <xsl:key name="elements-by-class" match="*" use="tokenize(@class, ' ')"/>
    <xsl:key name="violations-by-value" match="*" use="apl:violationValue/text()"/>
    <xsl:key name="resources-by-container" match="*[@rdf:about] | *[@rdf:nodeID]" use="sioc:has_parent/@rdf:resource | sioc:has_container/@rdf:resource"/>
    
    <xsl:strip-space elements="*"/>

    <!-- INITIAL TEMPLATE -->
    
    <xsl:template name="main">
        <xsl:message>xsl:product-name: <xsl:value-of select="system-property('xsl:product-name')"/></xsl:message>
        <xsl:message>saxon:platform: <xsl:value-of select="system-property('saxon:platform')"/></xsl:message>
        <xsl:message>$ac:contextUri: <xsl:value-of select="$ac:contextUri"/></xsl:message>
        <xsl:message>$ldt:base: <xsl:value-of select="$ldt:base"/></xsl:message>
        <xsl:message>$ldt:ontology: <xsl:value-of select="$ldt:ontology"/></xsl:message>
        <xsl:message>$ac:lang: <xsl:value-of select="$ac:lang"/></xsl:message>
        <xsl:message>$ac:uri: <xsl:value-of select="$ac:uri"/></xsl:message>
        <xsl:message>$ac:endpoint: <xsl:value-of select="$ac:endpoint"/></xsl:message>
        <xsl:message>$ac:forClass: <xsl:value-of select="$ac:forClass"/></xsl:message>
        <xsl:message>Search container URI: <xsl:value-of select="$search-container-uri"/></xsl:message>
        <xsl:message>$ac:limit: <xsl:value-of select="$ac:limit"/></xsl:message>
        <xsl:message>$ac:offset: <xsl:value-of select="$ac:offset"/></xsl:message>
        <xsl:message>$ac:order-by: <xsl:value-of select="$ac:order-by"/></xsl:message>
        <xsl:message>$ac:desc: <xsl:value-of select="$ac:desc"/></xsl:message>
        <xsl:message>$ac:mode: <xsl:value-of select="$ac:mode"/></xsl:message>
        <xsl:message>$ac:container-mode: <xsl:value-of select="$ac:container-mode"/></xsl:message>

        <!-- create a LinkedDataHub namespace -->
        <ixsl:set-property name="LinkedDataHub" select="ac:new-object()"/>
        <ixsl:set-property name="href" select="$ac:uri" object="ixsl:get(ixsl:window(), 'LinkedDataHub')"/>
        <ixsl:set-property name="local-href" select="$ac:uri" object="ixsl:get(ixsl:window(), 'LinkedDataHub')"/>
        <ixsl:set-property name="yasqe" select="ac:new-object()" object="ixsl:get(ixsl:window(), 'LinkedDataHub')"/>
        <!-- load application's ontology RDF document -->
<!--        <ixsl:schedule-action http-request="map{ 'method': 'GET', 'href': $ldt:ontology, 'headers': map{ 'Accept': 'application/rdf+xml' } }">
            <xsl:call-template name="onOntologyLoad"/>
        </ixsl:schedule-action>-->
        <!-- disable SPARQL editor's server-side submission -->
        <xsl:for-each select="ixsl:page()//button[contains(@class, 'btn-run-query')]"> <!-- TO-DO: use the 'elements-by-class' key -->
            <ixsl:set-attribute name="type" select="'button'"/> <!-- instead of "submit" -->
        </xsl:for-each>
        <!-- only show first time message for authenticated agents -->
        <xsl:if test="id('main-content', ixsl:page()) and not(ixsl:page()//div[tokenize(@class, ' ') = 'navbar']//a[tokenize(@class, ' ') = 'btn-primary'][text() = 'Sign up']) and not(contains(ixsl:get(ixsl:page(), 'cookie'), 'LinkedDataHub.first-time-message'))">
            <xsl:result-document href="#content-body" method="ixsl:append-content">
                <xsl:call-template name="first-time-message"/>
            </xsl:result-document>
        </xsl:if>
        <!-- initialize wymeditor textareas -->
        <xsl:apply-templates select="key('elements-by-class', 'wymeditor', ixsl:page())" mode="apl:PostConstructMode"/>
        <xsl:if test="not($ac:mode = '&ac;QueryEditorMode') and starts-with($ac:uri, $ldt:base)">
            <xsl:call-template name="apl:LoadBreadcrumbs">
                <xsl:with-param name="uri" select="$ac:uri"/>
            </xsl:call-template>
        </xsl:if>
        <!-- initialize SPARQL query service dropdown -->
        <xsl:for-each select="id('query-service', ixsl:page())">
            <xsl:variable name="service-select" select="." as="element()"/>
            <ixsl:schedule-action http-request="map{ 'method': 'GET', 'href': ac:build-uri(resolve-uri('sparql', $ldt:base), map{ 'query': $service-query }), 'headers': map{ 'Accept': 'application/rdf+xml' } }">
                <xsl:call-template name="onServiceLoad">
                    <xsl:with-param name="service-select" select="$service-select"/>
                    <xsl:with-param name="selected-service" select="$ac:service"/>
                </xsl:call-template>
            </ixsl:schedule-action>
        </xsl:for-each>
        <!--  append Save form to Query form -->
<!--        <xsl:for-each select="id('query-form', ixsl:page())/..">
            <xsl:result-document href="?." method="ixsl:append-content">
                <xsl:call-template name="bs2:SaveQueryForm">
                    <xsl:with-param name="query" select="ixsl:call(ixsl:get(ixsl:window(), 'yasqe'), 'getValue', [])" as="xs:string"/>  get query string from YASQE 
                </xsl:call-template>
            </xsl:result-document>
        </xsl:for-each>-->
        <!-- append typeahead list after the search/URI input -->
        <xsl:for-each select="id('uri', ixsl:page())/..">
            <xsl:result-document href="?." method="ixsl:append-content">
                <ul id="{generate-id()}" class="search-typeahead typeahead dropdown-menu"></ul>
            </xsl:result-document>
        </xsl:for-each>
        <!-- initialize services (and the search dropdown, if it's shown) -->
        <ixsl:schedule-action http-request="map{ 'method': 'GET', 'href': ac:build-uri(resolve-uri('sparql', $ldt:base), map{ 'query': $service-query }), 'headers': map{ 'Accept': 'application/rdf+xml' } }">
            <xsl:call-template name="onServiceLoad">
                <xsl:with-param name="service-select" select="id('search-service', ixsl:page())"/>
                <xsl:with-param name="selected-service" select="$ac:service"/>
            </xsl:call-template>
        </ixsl:schedule-action>
        <!-- load contents -->
        <xsl:variable name="content-ids" select="key('elements-by-class', 'resource-content', ixsl:page())/@id" as="xs:string*"/>
        <xsl:call-template name="apl:LoadContents">
            <xsl:with-param name="uri" select="$ac:uri"/>
            <xsl:with-param name="content-ids" select="$content-ids"/>
        </xsl:call-template>
        <!-- update RDF download links to match the current URI -->
        <xsl:for-each select="id('export-rdf', ixsl:page())/following-sibling::ul/li/a">
            <!-- use @title attribute for the media type TO-DO: find a better way, a hidden input or smth -->
            <xsl:variable name="href" select="ac:build-uri($ac:uri, map{ 'accept': string(@title) })" as="xs:anyURI"/>
            <ixsl:set-property name="href" select="$href" object="."/>
        </xsl:for-each>
    </xsl:template>

    <!-- FUNCTIONS -->
    
    <xsl:function name="ac:new-object">
        <xsl:variable name="js-statement" as="element()">
            <root statement="{{ }}"/>
        </xsl:variable>
        <xsl:sequence select="ixsl:eval(string($js-statement/@statement))"/>
    </xsl:function>
    
    <xsl:function name="ac:build-describe" as="xs:string">
        <xsl:param name="select-string" as="xs:string"/> <!-- already with ?this value set -->
        <xsl:param name="limit" as="xs:integer?"/>
        <xsl:param name="offset" as="xs:integer?"/>
        <xsl:param name="order-by" as="xs:string?"/>
        <xsl:param name="desc" as="xs:boolean"/>

        <xsl:variable name="select-builder" select="ixsl:call(ixsl:get(ixsl:get(ixsl:window(), 'SPARQLBuilder'), 'SelectBuilder'), 'fromString', [ $select-string ])"/>
        <!-- ignore ORDER BY variable name if it's not present in the query -->
        <xsl:variable name="order-by" select="if (ixsl:call($select-builder, 'isVariable', [ ixsl:call(ixsl:get(ixsl:get(ixsl:window(), 'SPARQLBuilder'), 'SelectBuilder'), 'var', [ $order-by ]) ])) then $order-by else ()" as="xs:string?"/>
        <xsl:variable name="select-builder" select="ac:paginate($select-builder, $limit, $offset, $order-by, $desc)"/>
        <xsl:variable name="describe-builder" select="ixsl:call(ixsl:call(ixsl:get(ixsl:get(ixsl:window(), 'SPARQLBuilder'), 'DescribeBuilder'), 'new', []), 'wherePattern', [ ixsl:call($select-builder, 'build', []) ])"/>
        <xsl:sequence select="ixsl:call($describe-builder, 'toString', [ ])"/>
    </xsl:function>
    
    <!-- accepts and returns SelectBuilder. Use ixsl:call(ac:paginate(...), 'toString', []) to get SPARQL string -->
    <xsl:function name="ac:paginate">
        <xsl:param name="select-builder"/> <!-- as SelectBuilder -->
        <xsl:param name="limit" as="xs:integer?"/>
        <xsl:param name="offset" as="xs:integer?"/>
        <xsl:param name="order-by" as="xs:string?"/>
        <xsl:param name="desc" as="xs:boolean?"/>

        <xsl:choose>
            <xsl:when test="$order-by and exists($desc)">
                <xsl:sequence select="ixsl:call(ixsl:call(ixsl:call($select-builder, 'limit', [ $limit ]), 'offset', [ $offset ]), 'orderBy', [ ixsl:call(ixsl:get(ixsl:get(ixsl:window(), 'SPARQLBuilder'), 'SelectBuilder'), 'ordering',  [ ixsl:call(ixsl:get(ixsl:get(ixsl:window(), 'SPARQLBuilder'), 'SelectBuilder'), 'var', [ $order-by ]), $desc ]) ])"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="ixsl:call(ixsl:call($select-builder, 'limit', [ $limit ]), 'offset', [ $offset ])"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!-- format URLs in DataTable as HTML links -->
    <xsl:template match="@rdf:about[starts-with(., 'http://')] | @rdf:about[starts-with(., 'https://')] | @rdf:resource[starts-with(., 'http://')] | @rdf:resource[starts-with(., 'https://')] | srx:uri[starts-with(., 'http://')] | srx:uri[starts-with(., 'https://')]" mode="ac:DataTable">
        "&lt;a href=\"<xsl:value-of select="."/>\"&gt;<xsl:value-of select="."/>&lt;/a&gt;"
    </xsl:template>

    <!-- in addition to JSON escaping, escape < > in literals so they don't get interpreted as HTML tags -->
    <xsl:template match="srx:literal[@datatype = '&xsd;string' or not(@datatype)]" mode="ac:DataTable">
        "<xsl:value-of select="replace(replace(replace(replace(replace(replace(replace(replace(., '\\', '\\\\'), '&quot;', '\\&quot;'), '/', '\\/'), '&#xA;', '\\n'), '&#xD;', '\\r'), '&#x9;', '\\t'), '&lt;', '&amp;lt;'), '&gt;', '&amp;gt;')"/>"
    </xsl:template>

    <!-- in addition to JSON escaping, escape < > in literals so they don't get interpreted as HTML tags -->
    <xsl:template match="rdf:Description/*/text()[../@rdf:datatype = '&xsd;string' or not(../@rdf:datatype)]" mode="ac:DataTable">
        "<xsl:value-of select="replace(replace(replace(replace(replace(replace(replace(replace(., '\\', '\\\\'), '&quot;', '\\&quot;'), '/', '\\/'), '&#xA;', '\\n'), '&#xD;', '\\r'), '&#x9;', '\\t'), '&lt;', '&amp;lt;'), '&gt;', '&amp;gt;')"/>"
    </xsl:template>
    
    <xsl:function name="ac:rdf-data-table">
        <xsl:param name="results" as="document-node()"/>
        <xsl:param name="category" as="xs:string?"/>
        <xsl:param name="series" as="xs:string*"/>
        
        <xsl:variable name="json" as="xs:string">
            <xsl:value-of>
                <xsl:choose>
                    <xsl:when test="$category">
                        <xsl:apply-templates select="$results" mode="ac:DataTable">
                            <xsl:with-param name="property-uris" select="xs:anyURI($category), for $i in $series return xs:anyURI($i)" tunnel="yes"/>
                        </xsl:apply-templates>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- if no $category specified, show resource URI/ID as category -->
                        <xsl:apply-templates select="$results" mode="ac:DataTable">
                            <xsl:with-param name="resource-ids" select="true()" tunnel="yes"/>
                            <xsl:with-param name="property-uris" select="xs:anyURI($category), for $i in $series return xs:anyURI($i)" tunnel="yes"/>
                        </xsl:apply-templates>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:value-of>
        </xsl:variable>
        
        <xsl:variable name="js-statement" as="element()">
            <root statement="new google.visualization.DataTable(JSON.parse(String.raw`{$json}`))"/>
        </xsl:variable>
        <xsl:sequence select="ixsl:eval(string($js-statement/@statement))"/>
    </xsl:function>
    
    <xsl:function name="ac:sparql-results-data-table">
        <xsl:param name="results" as="document-node()"/>
        <xsl:param name="category" as="xs:string?"/>
        <xsl:param name="series" as="xs:string*"/>
        
        <xsl:variable name="json" as="xs:string">
            <xsl:value-of>
                <xsl:apply-templates select="$results" mode="ac:DataTable">
                    <xsl:with-param name="var-names" select="$category, $series" tunnel="yes"/>
                </xsl:apply-templates>
            </xsl:value-of>
        </xsl:variable>

        <xsl:variable name="js-statement" as="element()">
            <root statement="new google.visualization.DataTable(JSON.parse(String.raw`{$json}`))"/>
        </xsl:variable>
        <xsl:sequence select="ixsl:eval(string($js-statement/@statement))"/>
    </xsl:function>
    
    <!-- TO-DO: make 'data-table' configurable -->
    <xsl:template name="ac:draw-chart">
        <xsl:param name="data-table"/>
        <xsl:param name="canvas-id" as="xs:string"/>
        <xsl:param name="chart-type" as="xs:anyURI"/>
        <xsl:param name="category" as="xs:string?"/>
        <xsl:param name="series" as="xs:string*"/>
        <xsl:param name="width" as="xs:string?"/>
        <xsl:param name="height" as="xs:string?"/>

        <xsl:variable name="chart-classes" as="map(xs:string, xs:string)">
            <xsl:map>
                <xsl:map-entry key="'&ac;Table'" select="'google.visualization.Table'"/>
                <xsl:map-entry key="'&ac;LineChart'" select="'google.visualization.LineChart'"/>
                <xsl:map-entry key="'&ac;BarChart'" select="'google.visualization.BarChart'"/>
                <xsl:map-entry key="'&ac;ScatterChart'" select="'google.visualization.ScatterChart'"/>
                <xsl:map-entry key="'&ac;Timeline'" select="'google.visualization.Timeline'"/>
            </xsl:map>
        </xsl:variable>
        <xsl:variable name="chart-class" select="map:get($chart-classes, $chart-type)" as="xs:string?"/>
        <xsl:if test="not($chart-class)">
            <xsl:message terminate="yes">
                Chart type '<xsl:value-of select="$chart-type"/>' unknown
            </xsl:message>
        </xsl:if>
        
        <xsl:variable name="js-statement" as="element()">
            <root statement="(new {$chart-class}(document.getElementById('{$canvas-id}')))"/>
        </xsl:variable>
        <xsl:variable name="chart" select="ixsl:eval(string($js-statement/@statement))"/>
                
        <xsl:choose>
            <xsl:when test="$chart-type = '&ac;Table'">
                <xsl:variable name="js-statement" as="element()">
                    <root statement="{{ allowHtml: true }}"/>
                </xsl:variable>
                <xsl:variable name="args" select="ixsl:eval(string($js-statement/@statement))"/>
                <xsl:sequence select="ixsl:call($chart, 'draw', [ $data-table, $args ])[current-date() lt xs:date('2000-01-01')]"/>
            </xsl:when>
            <xsl:when test="$chart-type = '&ac;BarChart'">
                <xsl:variable name="js-statement" as="element()">
                    <root statement="{{ allowHtml: true, hAxis: {{ title: '{$series}' }}, vAxis: {{ title: '{$category}' }} }}"/>
                </xsl:variable>
                <xsl:variable name="args" select="ixsl:eval(string($js-statement/@statement))"/>
                <xsl:sequence select="ixsl:call($chart, 'draw', [ $data-table, $args ])[current-date() lt xs:date('2000-01-01')]"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="js-statement" as="element()">
                    <root statement="{{ allowHtml: true, hAxis: {{ title: '{$category}' }}, vAxis: {{ title: '{$series}' }} }}"/>
                </xsl:variable>
                <xsl:variable name="args" select="ixsl:eval(string($js-statement/@statement))"/>
                <xsl:sequence select="ixsl:call($chart, 'draw', [ $data-table, $args ])[current-date() lt xs:date('2000-01-01')]"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- TEMPLATES -->
    
    <!-- we don't want to include per-vocabulary stylesheets -->
    
    <xsl:template match="*[*][@rdf:about] | *[*][@rdf:nodeID]" mode="ac:label">
        <xsl:choose>
            <xsl:when test="skos:prefLabel[lang($ac:lang)]">
                <xsl:sequence select="skos:prefLabel[lang($ac:lang)]/text()"/>
            </xsl:when>
            <xsl:when test="rdfs:label[lang($ac:lang)]">
                <xsl:sequence select="rdfs:label[lang($ac:lang)]/text()"/>
            </xsl:when>
            <xsl:when test="dct:title[lang($ac:lang)]">
                <xsl:sequence select="dct:title[lang($ac:lang)]/text()"/>
            </xsl:when>
            <xsl:when test="skos:prefLabel">
                <xsl:sequence select="skos:prefLabel/text()"/>
            </xsl:when>
            <xsl:when test="rdfs:label">
                <xsl:sequence select="rdfs:label/text()"/>
            </xsl:when>
            <xsl:when test="dct:title">
                <xsl:sequence select="dct:title/text()"/>
            </xsl:when>
            <xsl:when test="foaf:name">
                <xsl:sequence select="foaf:name/text()"/>
            </xsl:when>
            <xsl:when test="foaf:givenName and foaf:familyName">
                <xsl:sequence select="concat(foaf:givenName, ' ', foaf:familyName)"/>
            </xsl:when>
            <xsl:when test="foaf:familyName">
                <xsl:sequence select="foaf:familyName/text()"/>
            </xsl:when>
            <xsl:when test="foaf:nick">
                <xsl:sequence select="foaf:nick/text()"/>
            </xsl:when>
            <xsl:when test="sioc:name">
                <xsl:sequence select="sioc:name/text()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:next-match/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[*][@rdf:about] | *[*][@rdf:nodeID]" mode="ac:description">
        <xsl:choose>
            <xsl:when test="rdfs:comment[lang($ac:lang)]">
                <xsl:sequence select="rdfs:comment[lang($ac:lang)]/text()"/>
            </xsl:when>
            <xsl:when test="dct:description[lang($ac:lang)]">
                <xsl:sequence select="dct:description[lang($ac:lang)]/text()"/>
            </xsl:when>
            <xsl:when test="rdfs:comment">
                <xsl:sequence select="rdfs:comment/text()"/>
            </xsl:when>
            <xsl:when test="dct:description">
                <xsl:sequence select="dct:description/text()"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[*][@rdf:about] | *[*][@rdf:nodeID]" mode="ac:image">
        <xsl:choose>
            <xsl:when test="foaf:img/@rdf:resource">
                <xsl:sequence select="foaf:img/@rdf:resource"/>
            </xsl:when>
            <xsl:when test="foaf:depiction/@rdf:resource">
                <xsl:sequence select="foaf:depiction/@rdf:resource"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="*[@rdf:about = '&ac;ReadMode']" mode="apl:logo">
        <xsl:param name="class" as="xs:string?"/>
        
        <xsl:attribute name="class" select="concat($class, ' ', 'read-mode')"/>
        <xsl:sequence select="ac:label(.)"/>
    </xsl:template>
    
    <xsl:template match="*[@rdf:about = '&ac;ListMode']" mode="apl:logo">
        <xsl:param name="class" as="xs:string?"/>
        
        <xsl:attribute name="class" select="concat($class, ' ', 'list-mode')"/>
        <xsl:sequence select="ac:label(.)"/>
    </xsl:template>

    <xsl:template match="*[@rdf:about = '&ac;TableMode']" mode="apl:logo">
        <xsl:param name="class" as="xs:string?"/>
        
        <xsl:attribute name="class" select="concat($class, ' ', 'table-mode')"/>
        <xsl:sequence select="ac:label(.)"/>
    </xsl:template>
    
    <xsl:template match="*[@rdf:about = '&ac;GridMode']" mode="apl:logo">
        <xsl:param name="class" as="xs:string?"/>
        
        <xsl:attribute name="class" select="concat($class, ' ', 'grid-mode')"/>
        <xsl:sequence select="ac:label(.)"/>
    </xsl:template>

    <xsl:template match="*[@rdf:about = '&ac;ChartMode']" mode="apl:logo">
        <xsl:param name="class" as="xs:string?"/>
        
        <xsl:attribute name="class" select="concat($class, ' ', 'chart-mode')"/>
        <xsl:sequence select="ac:label(.)"/>
    </xsl:template>

    <xsl:template match="*[@rdf:about = '&ac;MapMode']" mode="apl:logo">
        <xsl:param name="class" as="xs:string?"/>
        
        <xsl:attribute name="class" select="concat($class, ' ', 'map-mode')"/>
        <xsl:sequence select="ac:label(.)"/>
    </xsl:template>
    
    <xsl:template match="*[@rdf:about = '&ac;GraphMode']" mode="apl:logo">
        <xsl:param name="class" as="xs:string?"/>
        
        <xsl:attribute name="class" select="concat($class, ' ', 'graph-mode')"/>
        <xsl:sequence select="ac:label(.)"/>
    </xsl:template>
    
    <!-- copied from rdf.xsl which is not imported -->
    <xsl:template match="rdf:type/@rdf:resource" priority="1">
        <span title="{.}" class="btn btn-type">
            <xsl:next-match/>
        </span>
    </xsl:template>
    
    <!-- copied from layout.xsl which is not imported -->
    <xsl:template match="*[*][@rdf:about]" mode="apl:Typeahead">
        <xsl:param name="id" select="generate-id()" as="xs:string"/>
        <xsl:param name="class" select="'btn add-typeahead'" as="xs:string?"/>
        <xsl:param name="disabled" select="false()" as="xs:boolean"/>
        <xsl:param name="title" select="@rdf:about" as="xs:string?"/>

        <button type="button">
            <xsl:if test="$id">
                <xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="$class">
                <xsl:attribute name="class"><xsl:value-of select="$class"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="$disabled">
                <xsl:attribute name="disabled">disabled</xsl:attribute>
            </xsl:if>
            <xsl:if test="$title">
                <xsl:attribute name="title"><xsl:value-of select="$title"/></xsl:attribute>
            </xsl:if>
            
            <span class="pull-left">
                <xsl:choose>
                    <xsl:when test="key('resources', foaf:primaryTopic/@rdf:resource)">
                        <xsl:value-of>
                            <xsl:apply-templates select="key('resources', foaf:primaryTopic/@rdf:resource)" mode="ac:label"/>
                        </xsl:value-of>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of>
                            <xsl:apply-templates select="." mode="ac:label"/>
                        </xsl:value-of>
                    </xsl:otherwise>
                </xsl:choose>
            </span>
            <span class="caret pull-right"></span>
            <input type="hidden" name="ou" value="{@rdf:about}"/>
        </button>
    </xsl:template>

    <!-- if document has a topic, show it as the typeahead value instead -->
    <xsl:template match="*[*][key('resources', foaf:primaryTopic/@rdf:resource)]" mode="apl:Typeahead" priority="1">
        <xsl:apply-templates select="key('resources', foaf:primaryTopic/@rdf:resource)" mode="#current"/>
    </xsl:template>
    
    <xsl:template match="rdf:RDF" mode="bs2:Right">
        <xsl:param name="id" as="xs:string?"/>
        <xsl:param name="class" select="'span4'" as="xs:string?"/>
        
        <div>
            <xsl:if test="$id">
                <xsl:attribute name="id"><xsl:sequence select="$id"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="$class">
                <xsl:attribute name="class"><xsl:sequence select="$class"/></xsl:attribute>
            </xsl:if>

            <xsl:apply-templates mode="#current"/>
        </div>
    </xsl:template>
    
    <!-- suppress most properties of the current document in the right nav, except some basic metadata -->
    <xsl:template match="*[@rdf:about = $ac:uri][dct:created or dct:modified or foaf:maker or acl:owner or foaf:primaryTopic or dh:select]" mode="bs2:Right" priority="1">
        <xsl:variable name="definitions" as="document-node()">
            <xsl:document>
                <dl class="dl-horizontal">
                    <xsl:apply-templates select="dct:created | dct:modified | foaf:maker | acl:owner | foaf:primaryTopic | dh:select" mode="bs2:PropertyList">
                        <xsl:sort select="ac:property-label(.)" order="ascending" lang="{$ldt:lang}"/>
                        <xsl:sort select="if (exists((text(), @rdf:resource, @rdf:nodeID))) then ac:object-label((text(), @rdf:resource, @rdf:nodeID)[1]) else()" order="ascending" lang="{$ldt:lang}"/>
                    </xsl:apply-templates>
                </dl>
            </xsl:document>
        </xsl:variable>

        <xsl:if test="$definitions/*/*">
            <div class="well well-small">
                <xsl:apply-templates select="$definitions" mode="bs2:PropertyListIdentity"/>
            </div>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="*[*][@rdf:about or @rdf:nodeID]" mode="bs2:Right"/>

    <!-- assuming SELECT query here. what do we do about DESCRIBE/CONSTRUCT? -->
    <xsl:template match="*[sp:text]" mode="apl:Content" priority="1">
        <xsl:param name="uri" as="xs:anyURI"/>
        <xsl:param name="container-id" as="xs:string"/>
        <!-- replace dots with dashes to avoid Saxon-JS treating them as field separators: https://saxonica.plan.io/issues/5031 -->
        <xsl:param name="content-uri" select="xs:anyURI(translate(@rdf:about, '.', '-'))" as="xs:anyURI"/>
        <xsl:param name="state" as="item()?"/>
        <!-- set ?this variable value unless getting the query string from state -->
        <xsl:variable name="select-string" select="if ($state?('&apl;content') = $content-uri) then string(map:get($state, '&sp;text')) else replace(sp:text, '\?this', concat('&lt;', $uri, '&gt;'))" as="xs:string"/>
        <xsl:variable name="select-json" as="item()">
            <xsl:choose>
                <!-- override $select-json with the query taken from $state -->
                <xsl:when test="$state?('&apl;content') = $content-uri">
                    <xsl:sequence select="map:get($state, '&spin;query')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="select-builder" select="ixsl:call(ixsl:get(ixsl:get(ixsl:window(), 'SPARQLBuilder'), 'SelectBuilder'), 'fromString', [ $select-string ])"/>
                    <xsl:sequence select="ixsl:call($select-builder, 'build', [])"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="select-json-string" select="ixsl:call(ixsl:get(ixsl:window(), 'JSON'), 'stringify', [ $select-json ])" as="xs:string"/>
        <xsl:variable name="select-xml" select="json-to-xml($select-json-string)" as="document-node()"/>
        <xsl:variable name="focus-var-name" select="$select-xml/json:map/json:array[@key = 'variables']/json:string[1]/substring-after(., '?')" as="xs:string"/>
        <xsl:variable name="service-uri" select="if ($state?('&apl;content') = $content-uri) then xs:anyURI(map:get($state, '&apl;service')) else xs:anyURI(apl:service/@rdf:resource)" as="xs:anyURI?"/>

        <!-- create new cache entry using content URI as key -->
        <ixsl:set-property name="{$content-uri}" select="ac:new-object()" object="ixsl:get(ixsl:window(), 'LinkedDataHub')"/>
        <!-- store this content element -->
        <ixsl:set-property name="content" select="." object="ixsl:get(ixsl:get(ixsl:window(), 'LinkedDataHub'), $content-uri)"/>
        <!-- store the initial SELECT query (without modifiers) -->
        <ixsl:set-property name="select-query" select="$select-string" object="ixsl:get(ixsl:get(ixsl:window(), 'LinkedDataHub'), $content-uri)"/>
        <!-- store the first var name of the initial SELECT query -->
        <ixsl:set-property name="focus-var-name" select="$focus-var-name" object="ixsl:get(ixsl:get(ixsl:window(), 'LinkedDataHub'), $content-uri)"/>
        <xsl:if test="$service-uri">
            <!-- store the URI of the service -->
            <ixsl:set-property name="service-uri" select="$service-uri" object="ixsl:get(ixsl:get(ixsl:window(), 'LinkedDataHub'), $content-uri)"/>
        </xsl:if>

        <xsl:variable name="select-xml" as="document-node()">
            <xsl:document>
                <xsl:apply-templates select="$select-xml" mode="apl:replace-limit">
                    <xsl:with-param name="limit" select="$ac:limit" tunnel="yes"/>
                </xsl:apply-templates>
            </xsl:document>
        </xsl:variable>
        <xsl:variable name="select-xml" as="document-node()">
            <xsl:document>
                <xsl:apply-templates select="$select-xml" mode="apl:replace-offset">
                    <xsl:with-param name="offset" select="$ac:offset" tunnel="yes"/>
                </xsl:apply-templates>
            </xsl:document>
        </xsl:variable>
        <xsl:call-template name="apl:PushContentState">
            <xsl:with-param name="href" select="ixsl:get(ixsl:window(), 'LinkedDataHub.href')"/>
            <xsl:with-param name="container-id" select="$container-id"/>
            <xsl:with-param name="content-uri" select="$content-uri"/>
            <xsl:with-param name="select-string" select="$select-string"/>
            <xsl:with-param name="select-xml" select="$select-xml"/>
            <xsl:with-param name="service-uri" select="$service-uri"/>
        </xsl:call-template>
        
        <!-- store the transformed query XML -->
        <ixsl:set-property name="select-xml" select="$select-xml" object="ixsl:get(ixsl:get(ixsl:window(), 'LinkedDataHub'), $content-uri)"/>
        <!-- update progress bar -->
        <ixsl:set-style name="width" select="'75%'" object="id($container-id, ixsl:page())//div[@class = 'bar']"/>

        <xsl:choose>
            <xsl:when test="$service-uri">
                <!-- load the service metadata first to get the endpoint URL -->
                <ixsl:schedule-action http-request="map{ 'method': 'GET', 'href': ac:document-uri($service-uri), 'headers': map{ 'Accept': 'application/rdf+xml' } }">
                    <xsl:call-template name="onContainerQueryServiceLoad">
                        <xsl:with-param name="container-id" select="$container-id"/>
                        <xsl:with-param name="content-uri" select="$content-uri"/>
                        <xsl:with-param name="content" select="."/>
                        <xsl:with-param name="select-string" select="$select-string"/>
                        <xsl:with-param name="select-xml" select="$select-xml"/>
                        <xsl:with-param name="focus-var-name" select="$focus-var-name"/>
                        <xsl:with-param name="service-uri" select="$service-uri"/>
                    </xsl:call-template>
                </ixsl:schedule-action>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="apl:RenderContainer">
                    <xsl:with-param name="container-id" select="$container-id"/>
                    <xsl:with-param name="content-uri" select="$content-uri"/>
                    <xsl:with-param name="content" select="."/>
                    <xsl:with-param name="select-string" select="$select-string"/>
                    <xsl:with-param name="select-xml" select="$select-xml"/>
                    <xsl:with-param name="focus-var-name" select="$focus-var-name"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="first-time-message">
        <div class="hero-unit">
            <button type="button" class="close">×</button>
            <h1>Your app is ready</h1>
            <h2>Deploy structured data, <em>without coding</em></h2>
            <p>Manage and publish RDF graph data, import CSV, create custom views and visualizations within minutes. Change app structure and API logic without writing code.</p>
            <p class="">
                <a href="https://linkeddatahub.com/demo/" class="float-left btn btn-primary btn-large" target="_blank">Check out demo apps</a>
                <a href="https://linkeddatahub.com/linkeddatahub/docs/" class="float-left btn btn-primary btn-large" target="_blank">Learn more</a>
            </p>
        </div>
    </xsl:template>
    
    <!-- CALLBACKS -->

    <!-- ontology loaded -->
<!--    <xsl:template name="ixsl:onOntologyLoad">
        <xsl:context-item as="map(*)" use="required"/>

        <xsl:for-each select="?status">
            <xsl:value-of select="ixsl:call(ixsl:window(), 'alert', [ . ])"/>
        </xsl:for-each>
    </xsl:template>-->
        
    <xsl:template name="onRDFBodyLoad">
        <xsl:context-item as="map(*)" use="required"/>
        <xsl:param name="uri" as="xs:anyURI"/>

        <xsl:for-each select="?body">
            <!-- focus on current resource -->
            <xsl:for-each select="key('resources', $uri)">
                <!-- breadcrumbs -->
                <xsl:if test="id('breadcrumb-nav', ixsl:page())">
                    <xsl:result-document href="#breadcrumb-nav" method="ixsl:replace-content">
                        <ul class="breadcrumb pull-left">
                            <xsl:apply-templates select="." mode="bs2:BreadCrumbListItem">
                                <xsl:with-param name="leaf" select="true()"/>
                            </xsl:apply-templates>
                        </ul>
                        <xsl:if test="not(starts-with($uri, $ldt:base))">
                            <span class="label label-info pull-left">External</span>
                        </xsl:if>
                    </xsl:result-document>

                    <xsl:variable name="parent-uri" select="sioc:has_container/@rdf:resource | sioc:has_parent/@rdf:resource" as="xs:anyURI?"/>
                    <xsl:if test="$parent-uri">
                        <ixsl:schedule-action http-request="map{ 'method': 'GET', 'href': $parent-uri, 'headers': map{ 'Accept': 'application/rdf+xml' } }">
                            <xsl:call-template name="apl:BreadCrumbResourceLoad">
                                <xsl:with-param name="id" select="'breadcrumb-nav'"/>
                                <xsl:with-param name="this-uri" select="$parent-uri"/>
                                <xsl:with-param name="leaf" select="false()"/>
                            </xsl:call-template>
                        </ixsl:schedule-action>
                    </xsl:if>
                </xsl:if>

                <!-- chart query -->
<!--                <xsl:for-each select="key('resources', foaf:primaryTopic/@rdf:resource)[spin:query][apl:chartType]">
                    <xsl:variable name="query-uri" select="xs:anyURI(spin:query/@rdf:resource)" as="xs:anyURI?"/>

                    <xsl:if test="$query-uri">
                        <xsl:variable name="chart-type" select="xs:anyURI(apl:chartType/@rdf:resource)" as="xs:anyURI?"/>
                        <xsl:variable name="category" select="apl:categoryProperty/@rdf:resource | apl:categoryVarName" as="xs:string?"/>
                        <xsl:variable name="series" select="apl:seriesProperty/@rdf:resource | apl:seriesVarName" as="xs:string*"/>

                        <ixsl:set-property name="chart-type" select="$chart-type" object="ixsl:get(ixsl:window(), 'LinkedDataHub')"/>
                        <ixsl:set-property name="category" select="$category" object="ixsl:get(ixsl:window(), 'LinkedDataHub')"/>
                        <ixsl:set-property name="series" select="$series" object="ixsl:get(ixsl:window(), 'LinkedDataHub')"/>

                         query progress bar 
                        <xsl:result-document href="#progress-bar" method="ixsl:replace-content">
                            <div class="progress progress-striped active">
                                <div class="bar" style="width: 40%;"></div>
                            </div>
                        </xsl:result-document>

                        <ixsl:schedule-action http-request="map{ 'method': 'GET', 'href': $query-uri, 'headers': map{ 'Accept': 'application/rdf+xml' } }">
                            <xsl:call-template name="onChartQueryLoad">
                                <xsl:with-param name="query-uri" select="$query-uri"/>
                                <xsl:with-param name="chart-type" select="$chart-type"/>
                                <xsl:with-param name="category" select="$category"/>
                                <xsl:with-param name="series" select="$series"/>
                            </xsl:call-template>
                        </ixsl:schedule-action>
                    </xsl:if>
                </xsl:for-each>-->
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="onContainerQueryServiceLoad">
        <xsl:context-item as="map(*)" use="required"/>
        <xsl:param name="container-id" as="xs:string"/>
        <xsl:param name="content-uri" as="xs:anyURI"/>
        <xsl:param name="content" as="element()?"/>
        <xsl:param name="select-string" as="xs:string"/>
        <xsl:param name="select-xml" as="document-node()"/>
        <xsl:param name="focus-var-name" as="xs:string"/>
        <xsl:param name="service-uri" as="xs:anyURI"/>
        
        <xsl:choose>
            <xsl:when test="?status = 200 and ?media-type = 'application/rdf+xml'">
                <xsl:for-each select="?body">
                    <xsl:variable name="service" select="key('resources', $service-uri)" as="element()"/>
                    <ixsl:set-property name="service" select="$service" object="ixsl:get(ixsl:get(ixsl:window(), 'LinkedDataHub'), $content-uri)"/>
                    
                    <xsl:call-template name="apl:RenderContainer">
                        <xsl:with-param name="container-id" select="$container-id"/>
                        <xsl:with-param name="content-uri" select="$content-uri"/>
                        <xsl:with-param name="content" select="$content"/>
                        <xsl:with-param name="select-string" select="$select-string"/>
                        <xsl:with-param name="select-xml" select="$select-xml"/>
                        <xsl:with-param name="service" select="$service"/>
                        <xsl:with-param name="focus-var-name" select="$focus-var-name"/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <!-- error response - could not load query results -->
                <xsl:call-template name="render-container-error">
                    <xsl:with-param name="container-id" select="$container-id"/>
                    <xsl:with-param name="message" select="?message"/>
                </xsl:call-template>
                <!--<xsl:value-of select="ixsl:call(ixsl:window(), 'alert', [ ?message ])"/>-->
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- when container RDF/XML results load, render them -->
    <xsl:template name="onContainerResultsLoad">
        <xsl:context-item as="map(*)" use="required"/>
        <xsl:param name="container-id" as="xs:string"/>
        <xsl:param name="content-uri" as="xs:anyURI"/>
        <xsl:param name="content" as="element()?"/>
        <xsl:param name="select-xml" as="document-node()"/>
        <xsl:param name="focus-var-name" as="xs:string"/>
        <xsl:param name="select-string" as="xs:string"/>
        <xsl:param name="service" as="element()?"/>

        <!-- update progress bar -->
        <xsl:for-each select="id($container-id, ixsl:page())//div[@class = 'bar']">
            <ixsl:set-style name="width" select="'75%'" object="."/>
        </xsl:for-each>

        <xsl:choose>
            <xsl:when test="?status = 200 and ?media-type = 'application/rdf+xml'">
                <xsl:for-each select="?body">
                    <!-- group descriptions by subject -->
                    <xsl:variable name="grouped-results" as="document-node()">
                        <xsl:apply-templates select="." mode="ac:GroupTriples"/>
                    </xsl:variable>
                    <ixsl:set-property name="results" select="$grouped-results" object="ixsl:get(ixsl:get(ixsl:window(), 'LinkedDataHub'), $content-uri)"/>

                    <!-- use the BGPs where the predicate is a URI value and the subject and object are variables -->
                    <xsl:variable name="bgp-triples-map" select="$select-xml//json:map[json:string[@key = 'type'] = 'bgp']/json:array[@key = 'triples']/json:map[json:string[@key = 'subject'] = '?' || $focus-var-name][not(starts-with(json:string[@key = 'predicate'], '?'))][starts-with(json:string[@key = 'object'], '?')]" as="element()*"/>
                    <xsl:variable name="order-by-var-name" select="$select-xml/json:map/json:array[@key = 'order']/json:map[1]/json:string[@key = 'expression']/substring-after(., '?')" as="xs:string?"/>
                    <xsl:variable name="order-by-predicate" select="$bgp-triples-map[json:string[@key = 'object'] = '?' || $order-by-var-name][1]/json:string[@key = 'predicate']" as="xs:anyURI?"/>
                    <xsl:variable name="desc" select="$select-xml/json:map/json:array[@key = 'order']/json:map[1]/json:boolean[@key = 'descending']" as="xs:boolean?"/>
                    <xsl:variable name="default-order-by-var-name" select="$select-xml/json:map/json:array[@key = 'order']/json:map[2]/json:string[@key = 'expression']/substring-after(., '?')" as="xs:string?"/>
                    <xsl:variable name="default-order-by-predicate" select="$bgp-triples-map[json:string[@key = 'object'] = '?' || $default-order-by-var-name][1]/json:string[@key = 'predicate']" as="xs:anyURI?"/>
                    <xsl:variable name="default-desc" select="$select-xml/json:map/json:array[@key = 'order']/json:map[2]/json:boolean[@key = 'descending']" as="xs:boolean?"/>
                    <xsl:variable name="active-class" select="id($container-id, ixsl:page())//ul[@class = 'nav nav-tabs']/li[tokenize(@class, ' ') = 'active']/tokenize(@class, ' ')[not(. = 'active')][1]" as="xs:string?"/>

                    <xsl:call-template name="render-container">
                        <xsl:with-param name="container-id" select="$container-id"/>
                        <xsl:with-param name="content-uri" select="$content-uri"/>
                        <xsl:with-param name="content" select="$content"/>
                        <xsl:with-param name="results" select="$grouped-results"/>
                        <xsl:with-param name="focus-var-name" select="$focus-var-name"/>
                        <xsl:with-param name="order-by-predicate" select="$order-by-predicate"/>
                        <xsl:with-param name="desc" select="$desc"/>
                        <xsl:with-param name="default-order-by-var-name" select="$default-order-by-var-name"/>
                        <xsl:with-param name="default-order-by-predicate" select="$default-order-by-predicate"/>
                        <xsl:with-param name="default-desc" select="$default-desc"/>
                        <xsl:with-param name="select-xml" select="$select-xml"/>
                        <xsl:with-param name="active-class" select="$active-class"/>
                    </xsl:call-template>

                    <!-- only append facets if they are not already present -->
                    <xsl:if test="not(id($container-id, ixsl:page())/preceding-sibling::div[tokenize(@class, ' ') = 'left-nav']/*)">
                        <xsl:variable name="facet-container-id" select="$container-id || '-left-nav'" as="xs:string"/>
                        
                        <xsl:for-each select="id($container-id, ixsl:page())/preceding-sibling::div[tokenize(@class, ' ') = 'left-nav']">
                            <xsl:result-document href="?." method="ixsl:append-content">
                                <div id="{$facet-container-id}" class="well well-small"/>
                            </xsl:result-document>
                        </xsl:for-each>
                        
                        <!-- use the initial (not the current, transformed) SELECT query and focus var name for facet rendering -->
                        <xsl:variable name="select-builder" select="ixsl:call(ixsl:get(ixsl:get(ixsl:window(), 'SPARQLBuilder'), 'SelectBuilder'), 'fromString', [ $select-string ])"/>
                        <xsl:variable name="select-json-string" select="ixsl:call(ixsl:get(ixsl:window(), 'JSON'), 'stringify', [ ixsl:call($select-builder, 'build', []) ])" as="xs:string"/>
                        <xsl:variable name="select-xml" select="json-to-xml($select-json-string)" as="document-node()"/>
                        <xsl:variable name="focus-var-name" select="$select-xml/json:map/json:array[@key = 'variables']/json:string[1]/substring-after(., '?')" as="xs:string"/>

                        <xsl:call-template name="render-facets">
                            <xsl:with-param name="focus-var-name" select="$focus-var-name"/>
                            <xsl:with-param name="select-xml" select="$select-xml"/>
                            <xsl:with-param name="container-id" select="$facet-container-id"/>
                        </xsl:call-template>
                    </xsl:if>

                    <!-- result counts -->
                    <!-- <xsl:if test="id('result-counts', ixsl:page())">
                        <xsl:call-template name="apl:ResultCounts">
                            <xsl:with-param name="focus-var-name" select="$focus-var-name"/>
                            <xsl:with-param name="select-xml" select="$select-xml"/>
                        </xsl:call-template>
                    </xsl:if> -->

                    <!-- only show parallax navigation if the RDF result contains object resources -->
                    <xsl:if test="$grouped-results/rdf:RDF/*/*[@rdf:resource]">
                        <xsl:variable name="parallax-container-id" select="$container-id || '-right-nav'" as="xs:string"/>

                        <!-- create a container for parallax controls in the right-nav, if it doesn't exist yet -->
                        <xsl:if test="not(id($container-id, ixsl:page())/following-sibling::div[tokenize(@class, ' ') = 'right-nav']/*)">
                            <xsl:for-each select="id($container-id, ixsl:page())/following-sibling::div[tokenize(@class, ' ') = 'right-nav']">
                                <xsl:result-document href="?." method="ixsl:append-content">
                                    <div id="{$parallax-container-id}" class="well well-small sidebar-nav parallax-nav"/>
                                </xsl:result-document>
                            </xsl:for-each>
                        </xsl:if>

                        <xsl:call-template name="bs2:Parallax">
                            <xsl:with-param name="results" select="$grouped-results"/>
                            <xsl:with-param name="select-xml" select="$select-xml"/>
                            <xsl:with-param name="service" select="$service"/>
                            <xsl:with-param name="container-id" select="$parallax-container-id"/>
                        </xsl:call-template>
                    </xsl:if>
                    
                    <ixsl:set-style name="cursor" select="'default'" object="ixsl:page()//body"/>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <!-- error response - could not load query results -->
                <xsl:call-template name="render-container-error">
                    <xsl:with-param name="message" select="?message"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        
        <!-- loading is done - restore the default mouse cursor -->
        <ixsl:set-style name="cursor" select="'default'" object="ixsl:page()//body"/>
    </xsl:template>
    
    <xsl:template name="render-container">
        <xsl:param name="container-id" as="xs:string"/>
        <xsl:param name="content-uri" as="xs:anyURI"/>
        <xsl:param name="content" as="element()?"/>
        <xsl:param name="results" as="document-node()"/>
        <xsl:param name="focus-var-name" as="xs:string"/>
        <xsl:param name="order-by-predicate" as="xs:anyURI?"/>
        <xsl:param name="desc" as="xs:boolean?"/>
        <xsl:param name="default-order-by-predicate" as="xs:anyURI?"/>
        <xsl:param name="default-order-by-var-name" as="xs:string?"/>
        <xsl:param name="default-desc" as="xs:boolean?"/>
        <xsl:param name="active-class" select="'list-mode'" as="xs:string?"/>
        <xsl:param name="select-xml" as="document-node()"/>
        <xsl:param name="order-by-container-id" select="$container-id || '-container-order'" as="xs:string?"/>

        <!-- hide progress bar -->
        <xsl:for-each select="id($container-id, ixsl:page())//div[@class = 'progress-bar']">
            <ixsl:set-style name="display" select="'none'" object="."/>
        </xsl:for-each>
                
        <xsl:choose>
            <!-- container results are already rendered - replace the content of the div -->
            <xsl:when test="id($container-id, ixsl:page())/div[ul]">
                <xsl:for-each select="id($container-id, ixsl:page())/div[ul]">
                    <xsl:result-document href="?." method="ixsl:replace-content">
                        <xsl:call-template name="container-mode">
                            <xsl:with-param name="container-id" select="$container-id"/>
                            <xsl:with-param name="select-xml" select="$select-xml"/>
                            <xsl:with-param name="results" select="$results"/>
                            <xsl:with-param name="order-by-predicate" select="$order-by-predicate"/>
                            <xsl:with-param name="desc" select="$desc"/>
                            <xsl:with-param name="default-order-by-predicate" select="$default-order-by-predicate"/>
                            <xsl:with-param name="default-desc" select="$default-desc"/>
                            <xsl:with-param name="active-class" select="$active-class"/>
                        </xsl:call-template>
                    </xsl:result-document>
                </xsl:for-each>
            </xsl:when>
            <!-- first time rendering the container results -->
            <xsl:otherwise>
                <!-- use the BGPs where the predicate is a URI value and the subject and object are variables -->
                <xsl:variable name="bgp-triples-map" select="$select-xml//json:map[json:string[@key = 'type'] = 'bgp']/json:array[@key = 'triples']/json:map[json:string[@key = 'subject'] = '?' || $focus-var-name][not(starts-with(json:string[@key = 'predicate'], '?'))][starts-with(json:string[@key = 'object'], '?')]" as="element()*"/>
                
                <xsl:for-each select="$bgp-triples-map">
                    <xsl:variable name="id" select="generate-id()" as="xs:string"/>
                    <xsl:variable name="predicate" select="json:string[@key = 'predicate']" as="xs:anyURI"/>
                    <xsl:variable name="results-uri" select="ac:build-uri($ldt:base, map{ 'uri': string($predicate), 'accept': 'application/rdf+xml', 'mode': 'fragment' })" as="xs:anyURI"/>

                    <ixsl:schedule-action http-request="map{ 'method': 'GET', 'href': $results-uri, 'headers': map{ 'Accept': 'application/rdf+xml' } }">
                        <xsl:call-template name="bs2:OrderBy">
                            <xsl:with-param name="container-id" select="$order-by-container-id"/>
                            <xsl:with-param name="id" select="$id"/>
                            <xsl:with-param name="predicate" select="$predicate"/>
                            <xsl:with-param name="order-by-predicate" select="$order-by-predicate" as="xs:anyURI?"/>
                        </xsl:call-template>
                    </ixsl:schedule-action>
                </xsl:for-each>

                <xsl:result-document href="#{$container-id}" method="ixsl:append-content">
                    <div class="pull-right">
                        <form class="form-inline">
                            <label for="{$order-by-container-id}">
                                <!-- currently no space for the label in the layout -->
                                <!--<xsl:text>Order by </xsl:text>-->
                                
                                <select id="{$order-by-container-id}" name="order-by" class="input-medium container-order">
                                    <!-- show the default option if the container query does not have an ORDER BY -->
                                    <xsl:if test="not($select-xml/json:map/json:array[@key = 'order'])">
                                        <option>[None]</option>
                                    </xsl:if>
                                </select>
                                
                                <xsl:choose>
                                    <xsl:when test="not($desc)">
                                        <button type="button" class="btn btn-order-by">Ascending</button>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <button type="button" class="btn btn-order-by btn-order-by-desc">Descending</button>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </label>
                        </form>
                    </div>
                    
                    <div>
<!--                        <h2>
                            <xsl:for-each select="$content">
                                <xsl:apply-templates select="." mode="apl:logo"/>
                                <xsl:text> </xsl:text>
                                <xsl:apply-templates select="." mode="xhtml:Anchor"/>
                            </xsl:for-each>
                        </h2>-->
                        
                        <xsl:call-template name="container-mode">
                            <xsl:with-param name="container-id" select="$container-id"/>
                            <xsl:with-param name="select-xml" select="$select-xml"/>
                            <xsl:with-param name="results" select="$results"/>
                            <xsl:with-param name="order-by-predicate" select="$order-by-predicate"/>
                            <xsl:with-param name="desc" select="$desc"/>
                            <xsl:with-param name="default-order-by-predicate" select="$default-order-by-predicate"/>
                            <xsl:with-param name="default-desc" select="$default-desc"/>
                            <xsl:with-param name="active-class" select="$active-class"/>
                        </xsl:call-template>
                    </div>
                </xsl:result-document>
            </xsl:otherwise>
        </xsl:choose>

        <!-- after we've created the map or chart container element, create the JS objects using it -->
        <xsl:if test="$active-class = 'map-mode' or (not($active-class) and $ac:container-mode = '&ac;MapMode')">
            <xsl:variable name="canvas-id" select="$container-id || '-map-canvas'" as="xs:string"/>
            <xsl:variable name="initial-load" select="not(ixsl:contains(ixsl:get(ixsl:get(ixsl:window(), 'LinkedDataHub'), $content-uri), 'map'))" as="xs:boolean"/>
            <!-- reuse center and zoom if map object already exists, otherwise set defaults -->
            <xsl:variable name="center-lat" select="if (not($initial-load)) then xs:float(ixsl:call(ixsl:call(ixsl:get(ixsl:get(ixsl:get(ixsl:window(), 'LinkedDataHub'), $content-uri), 'map'), 'getCenter', []), 'lat', [])) else 56" as="xs:float"/>
            <xsl:variable name="center-lng" select="if (not($initial-load)) then xs:float(ixsl:call(ixsl:call(ixsl:get(ixsl:get(ixsl:get(ixsl:window(), 'LinkedDataHub'), $content-uri), 'map'), 'getCenter', []), 'lng', [])) else 10" as="xs:float"/>
            <xsl:variable name="zoom" select="if (not($initial-load)) then xs:integer(ixsl:call(ixsl:get(ixsl:get(ixsl:get(ixsl:window(), 'LinkedDataHub'), $content-uri), 'map'), 'getZoom', [])) else 4" as="xs:integer"/>
            
            <ixsl:set-property name="map" select="ac:create-map($canvas-id, $center-lat, $center-lng, $zoom)" object="ixsl:get(ixsl:get(ixsl:window(), 'LinkedDataHub'), $content-uri)"/>

            <!-- unset LIMIT and OFFSET - we want all of the container's children on the map -->
            <xsl:variable name="select-xml" as="document-node()">
                <xsl:document>
                    <xsl:apply-templates select="$select-xml" mode="apl:replace-limit"/>
                </xsl:document>
            </xsl:variable>
            <xsl:variable name="select-xml" as="document-node()">
                <xsl:document>
                    <xsl:apply-templates select="$select-xml" mode="apl:replace-offset"/>
                </xsl:document>
            </xsl:variable>
            <xsl:variable name="select-json-string" select="xml-to-json($select-xml)" as="xs:string"/>
            <xsl:variable name="select-json" select="ixsl:call(ixsl:get(ixsl:window(), 'JSON'), 'parse', [ $select-json-string ])"/>
            <xsl:variable name="select-string" select="ixsl:call(ixsl:call(ixsl:get(ixsl:get(ixsl:window(), 'SPARQLBuilder'), 'SelectBuilder'), 'fromQuery', [ $select-json ]), 'toString', [])" as="xs:string"/>
            <xsl:variable name="service" select="if (ixsl:contains(ixsl:window(), 'LinkedDataHub.service')) then ixsl:get(ixsl:window(), 'LinkedDataHub.service') else ()" as="element()?"/>
            <xsl:variable name="endpoint" select="xs:anyURI(($service/sd:endpoint/@rdf:resource, (if ($service/dydra:repository/@rdf:resource) then ($service/dydra:repository/@rdf:resource || 'sparql') else ()), $ac:endpoint)[1])" as="xs:anyURI"/>
            <!-- do not use the initial LinkedDataHub.focus-var-name since parallax is changing the SELECT var name -->
            <xsl:variable name="focus-var-name" select="$select-xml/json:map/json:array[@key = 'variables']/json:string[1]/substring-after(., '?')" as="xs:string"/>
            <!-- to begin with, focus var is in the subject position, but becomes object after parallax, so we select a union of those -->
            <xsl:variable name="bgp-triples-map" select="$select-xml//json:map[json:string[@key = 'type'] = 'bgp']/json:array[@key = 'triples']/json:map[json:string[@key = 'subject'] = '?' || $focus-var-name][not(starts-with(json:string[@key = 'predicate'], '?'))][starts-with(json:string[@key = 'object'], '?')] | $select-xml//json:map[json:string[@key = 'type'] = 'bgp']/json:array[@key = 'triples']/json:map[starts-with(json:string[@key = 'subject'], '?')][not(starts-with(json:string[@key = 'predicate'], '?'))][json:string[@key = 'object'] = '?' || $focus-var-name]" as="element()*"/>
            <xsl:variable name="graph-var-name" select="$bgp-triples-map/ancestor::json:map[json:string[@key = 'type'] = 'graph'][1]/json:string[@key = 'name']/substring-after(., '?')" as="xs:string?"/>

            <ixsl:set-property name="geo" select="ac:create-geo-object($content-uri, $ac:uri, $endpoint, $select-string, $focus-var-name, $graph-var-name)" object="ixsl:get(ixsl:get(ixsl:window(), 'LinkedDataHub'), $content-uri)"/>

            <xsl:call-template name="ac:add-geo-listener">
                <xsl:with-param name="content-uri" select="$content-uri"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="$active-class = 'chart-mode' or (not($active-class) and $ac:container-mode = '&ac;ChartMode')">
            <xsl:variable name="canvas-id" select="$container-id || '-chart-canvas'" as="xs:string"/>
            <xsl:variable name="chart-type" select="xs:anyURI('&ac;Table')" as="xs:anyURI"/>
            <xsl:variable name="category" as="xs:string?"/>
            <xsl:variable name="series" select="distinct-values($results/*/*/concat(namespace-uri(), local-name()))" as="xs:string*"/>
            <xsl:variable name="data-table" select="ac:rdf-data-table($results, $category, $series)"/>
            
            <ixsl:set-property name="data-table" select="$data-table" object="ixsl:get(ixsl:get(ixsl:window(), 'LinkedDataHub'), $content-uri)"/>

            <xsl:call-template name="render-chart">
                <xsl:with-param name="data-table" select="$data-table"/>
                <xsl:with-param name="canvas-id" select="$canvas-id"/>
                <xsl:with-param name="chart-type" select="$chart-type"/>
                <xsl:with-param name="category" select="$category"/>
                <xsl:with-param name="series" select="$series"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="render-container-error">
        <xsl:param name="container-id" as="xs:string"/>
        <xsl:param name="message" as="xs:string"/>

        <!-- update progress bar -->
        <ixsl:set-style name="display" select="'none'" object="id($container-id, ixsl:page())//div[@class = 'bar']"/>
        
        <xsl:choose>
            <!-- container results are already rendered -->
            <xsl:when test="id('container-pane', ixsl:page())">
                <xsl:result-document href="#container-pane" method="ixsl:replace-content">
                    <div class="alert alert-block">
                        <strong>Error during query execution:</strong>
                        <pre>
                            <xsl:value-of select="$message"/>
                        </pre>
                    </div>
                </xsl:result-document>
            </xsl:when>
            <!-- first time rendering the container results -->
            <xsl:otherwise>
                <xsl:result-document href="#main-content" method="ixsl:append-content">
                    <div id="container-pane">
                        <div class="alert alert-block">
                            <strong>Error during query execution:</strong>
                            <pre>
                                <xsl:value-of select="$message"/>
                            </pre>
                        </div>
                    </div>
                </xsl:result-document>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="render-facets">
        <xsl:param name="select-xml" as="document-node()"/>
        <!-- use the first SELECT variable as the facet variable name (so that we do not generate facets based on other variables) -->
        <xsl:param name="focus-var-name" as="xs:string"/>
        <xsl:param name="container-id" as="xs:string"/>

        <!-- use the BGPs where the predicate is a URI value and the subject and object are variables -->
        <xsl:variable name="bgp-triples-map" select="$select-xml//json:map[json:string[@key = 'type'] = 'bgp']/json:array[@key = 'triples']/json:map[json:string[@key = 'subject'] = '?' || $focus-var-name][not(starts-with(json:string[@key = 'predicate'], '?'))][starts-with(json:string[@key = 'object'], '?')]" as="element()*"/>

        <xsl:for-each select="$bgp-triples-map">
            <xsl:variable name="id" select="generate-id()" as="xs:string"/>
            <xsl:variable name="subject-var-name" select="json:string[@key = 'subject']/substring-after(., '?')" as="xs:string"/>
            <xsl:variable name="predicate" select="json:string[@key = 'predicate']" as="xs:anyURI"/>
            <xsl:variable name="object-var-name" select="json:string[@key = 'object']/substring-after(., '?')" as="xs:string"/>
            <xsl:variable name="results-uri" select="ac:build-uri($ldt:base, map{ 'uri': string($predicate), 'accept': 'application/rdf+xml', 'mode': 'fragment' })" as="xs:anyURI"/>

            <ixsl:schedule-action http-request="map{ 'method': 'GET', 'href': $results-uri, 'headers': map{ 'Accept': 'application/rdf+xml' } }">
                <xsl:call-template name="bs2:FilterIn">
                    <xsl:with-param name="container-id" select="$container-id"/>
                    <xsl:with-param name="id" select="$id"/>
                    <xsl:with-param name="subject-var-name" select="$subject-var-name"/>
                    <xsl:with-param name="predicate" select="$predicate"/>
                    <xsl:with-param name="object-var-name" select="$object-var-name"/>
                </xsl:call-template>
            </ixsl:schedule-action>
        </xsl:for-each>
    </xsl:template>
    
    <!-- container results layout -->
    
    <xsl:template name="container-mode">
        <xsl:param name="container-id" as="xs:string"/>
        <xsl:param name="select-xml" as="document-node()"/>
        <xsl:param name="results" as="document-node()"/>
        <xsl:param name="order-by-predicate" as="xs:anyURI?"/>
        <xsl:param name="desc" as="xs:boolean?"/>
        <xsl:param name="default-order-by-predicate" as="xs:anyURI?"/>
        <xsl:param name="default-desc" as="xs:boolean?"/>
        <xsl:param name="active-class" as="xs:string?"/>
        
        <ul class="nav nav-tabs">
            <li class="read-mode">
                <xsl:if test="$active-class = 'read-mode' or (not($active-class) and $ac:container-mode = '&ac;ReadMode')">
                    <xsl:attribute name="class" select="'read-mode active'"/>
                </xsl:if>

                <a>
                    <xsl:apply-templates select="key('resources', '&ac;ReadMode', document(ac:document-uri('&ac;')))" mode="apl:logo"/>
                </a>
            </li>
            <li class="list-mode">
                <xsl:if test="$active-class = 'list-mode' or (not($active-class) and $ac:container-mode = '&ac;ListMode')">
                    <xsl:attribute name="class" select="'list-mode active'"/>
                </xsl:if>

                <a>
                    <xsl:apply-templates select="key('resources', '&ac;ListMode', document(ac:document-uri('&ac;')))" mode="apl:logo"/>
                </a>
            </li>
            <li class="table-mode">
                <xsl:if test="$active-class = 'table-mode' or (not($active-class) and $ac:container-mode = '&ac;TableMode')">
                    <xsl:attribute name="class" select="'table-mode active'"/>
                </xsl:if>

                <a>
                    <xsl:apply-templates select="key('resources', '&ac;TableMode', document(ac:document-uri('&ac;')))" mode="apl:logo"/>
                </a>
            </li>
            <li class="grid-mode">
                <xsl:if test="$active-class = 'grid-mode' or (not($active-class) and $ac:container-mode = '&ac;GridMode')">
                    <xsl:attribute name="class" select="'grid-mode active'"/>
                </xsl:if>

                <a>
                    <xsl:apply-templates select="key('resources', '&ac;GridMode', document(ac:document-uri('&ac;')))" mode="apl:logo"/>
                </a>
            </li>
            <li class="chart-mode">
                <xsl:if test="$active-class = 'chart-mode' or (not($active-class) and $ac:container-mode = '&ac;ChartMode')">
                    <xsl:attribute name="class" select="'chart-mode active'"/>
                </xsl:if>

                <a>
                    <xsl:apply-templates select="key('resources', '&ac;ChartMode', document(ac:document-uri('&ac;')))" mode="apl:logo"/>
                </a>
            </li>
            <li class="map-mode">
                <xsl:if test="$active-class = 'map-mode' or (not($active-class) and $ac:container-mode = '&ac;MapMode')">
                    <xsl:attribute name="class" select="'map-mode active'"/>
                </xsl:if>

                <a>
                    <xsl:apply-templates select="key('resources', '&ac;MapMode', document(ac:document-uri('&ac;')))" mode="apl:logo"/>
                </a>
            </li>
            <li class="graph-mode">
                <xsl:if test="$active-class = 'graph-mode' or (not($active-class) and $ac:container-mode = '&ac;GraphMode')">
                    <xsl:attribute name="class" select="'graph-mode active'"/>
                </xsl:if>

                <a>
                    <xsl:apply-templates select="key('resources', '&ac;GraphMode', document(ac:document-uri('&ac;')))" mode="apl:logo"/>
                </a>
            </li>
        </ul>

        <div class="container-results">
            <xsl:variable name="sorted-results" as="document-node()">
                <xsl:document>
                    <xsl:for-each select="$results/rdf:RDF">
                        <xsl:copy>
                            <xsl:perform-sort select="*">
                                <!-- sort by $order-by-predicate if it is set (multiple properties might match) -->
                                <xsl:sort select="if ($order-by-predicate) then *[concat(namespace-uri(), local-name()) = $order-by-predicate][1] else ()" order="{if ($desc) then 'descending' else 'ascending'}"/>
                                <!-- sort by $default-order-by-predicate if it is set and not equal to $order-by-predicate (multiple properties might match) -->
                                <xsl:sort select="if ($default-order-by-predicate and not($order-by-predicate = $default-order-by-predicate)) then *[concat(namespace-uri(), local-name()) = $default-order-by-predicate][1] else ()" order="{if ($default-desc) then 'descending' else 'ascending'}"/>
                                <!-- soft by URI/bnode ID otherwise -->
                                <xsl:sort select="if (@rdf:about) then @rdf:about else @rdf:nodeID"/>
                            </xsl:perform-sort>
                        </xsl:copy>
                    </xsl:for-each>
                </xsl:document>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="$active-class = 'list-mode' or (not($active-class) and $ac:container-mode = '&ac;ListMode')">
                    <xsl:apply-templates select="$sorted-results" mode="bs2:BlockList">
                        <xsl:with-param name="select-xml" select="$select-xml"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:when test="$active-class = 'table-mode' or (not($active-class) and $ac:container-mode = '&ac;TableMode')">
                    <xsl:apply-templates select="$sorted-results" mode="xhtml:Table">
                        <xsl:with-param name="select-xml" select="$select-xml"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:when test="$active-class = 'grid-mode' or (not($active-class) and $ac:container-mode = '&ac;GridMode')">
                    <xsl:apply-templates select="$sorted-results" mode="bs2:Grid">
                        <xsl:with-param name="select-xml" select="$select-xml"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:when test="$active-class = 'chart-mode' or (not($active-class) and $ac:container-mode = '&ac;ChartMode')">
                    <xsl:apply-templates select="$sorted-results" mode="bs2:Chart">
                        <xsl:with-param name="canvas-id" select="$container-id || '-chart-canvas'"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:when test="$active-class = 'map-mode' or (not($active-class) and $ac:container-mode = '&ac;MapMode')">
                    <xsl:apply-templates select="$sorted-results" mode="bs2:Map">
                        <xsl:with-param name="canvas-id" select="$container-id || '-map-canvas'"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:when test="$active-class = 'graph-mode' or (not($active-class) and $ac:container-mode = '&ac;GraphMode')">
                    <xsl:apply-templates select="$sorted-results" mode="bs2:Graph"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="$sorted-results" mode="bs2:Block"/>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>
    
    <!-- push states -->
    
    <xsl:template name="apl:PushContentState">
         <!-- has to be a proxied URI with the actual URI encoded as ?uri, otherwise we get a "DOMException: The operation is insecure" -->
        <xsl:param name="href" as="xs:anyURI"/>
        <xsl:param name="title" as="xs:string?"/>
        <xsl:param name="select-string" as="xs:string"/>
        <xsl:param name="select-xml" as="document-node()"/>
        <xsl:param name="container-id" as="xs:string"/>
        <xsl:param name="content-uri" as="xs:anyURI"/>
        <xsl:param name="service-uri" as="xs:anyURI?"/>
        <!-- we need to escape the backslashes with replace() before passing the JSON string to JSON.parse() -->
        <xsl:variable name="select-json-string" select="replace(xml-to-json($select-xml), '\\', '\\\\')" as="xs:string"/>
        <!-- push the latest state into history. TO-DO: generalize both cases -->
        <xsl:choose>
            <xsl:when test="$service-uri">
                <xsl:variable name="js-statement" as="element()">
                    <root statement="history.pushState({{ 'href': '{$href}', 'container-id': '{$container-id}', '&apl;content': '{$content-uri}', '&sp;text': '{ac:escape-json($select-string)}', '&spin;query': JSON.parse('{$select-json-string}'), '&apl;service': '{$service-uri}' }}, '{$title}')"/>
                </xsl:variable>
                <xsl:sequence select="ixsl:eval(string($js-statement/@statement))[current-date() lt xs:date('2000-01-01')]"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="js-statement" as="element()">
                    <root statement="history.pushState({{ 'href': '{$href}', 'container-id': '{$container-id}', '&apl;content': '{$content-uri}', '&sp;text': '{ac:escape-json($select-string)}', '&spin;query': JSON.parse('{$select-json-string}') }}, '{$title}')"/>
                </xsl:variable>
                <xsl:sequence select="ixsl:eval(string($js-statement/@statement))[current-date() lt xs:date('2000-01-01')]"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="apl:PushState">
         <!-- has to be a proxied URI with the actual URI encoded as ?uri, otherwise we get a "DOMException: The operation is insecure" -->
        <xsl:param name="href" as="xs:anyURI"/>
        <xsl:param name="title" as="xs:string?"/>
        <!-- push the latest state into history -->
        <xsl:variable name="js-statement" as="element()">
            <root statement="history.pushState({{ 'href': '{$href}' }}, '{$title}', '{$href}')"/>
        </xsl:variable>
        <xsl:sequence select="ixsl:eval(string($js-statement/@statement))[current-date() lt xs:date('2000-01-01')]"/>
    </xsl:template>
    
    <!-- load contents -->
    
    <xsl:template name="apl:LoadContents">
        <xsl:param name="uri" as="xs:anyURI"/>
        <xsl:param name="content-ids" as="xs:string*"/> <!-- workaround for Saxon-JS bug: https://saxonica.plan.io/issues/5036 -->
        <xsl:param name="state" as="item()?"/>

<!--        <xsl:for-each select="key('elements-by-class', 'resource-content', ixsl:page())">-->
        <xsl:if test="exists($content-ids)">
            <xsl:for-each select="id($content-ids, ixsl:page())">
                <xsl:variable name="content-uri" select="input[@name = 'href']/@value"/>
                <xsl:variable name="container-id" select="@id"/>

                <!-- show progress bar -->
                <xsl:result-document href="?." method="ixsl:append-content">
                    <div class="progress-bar">
                        <div class="progress progress-striped active">
                            <div class="bar" style="width: 25%;"></div>
                        </div>
                    </div>
                </xsl:result-document>

                <ixsl:schedule-action http-request="map{ 'method': 'GET', 'href': ac:document-uri($content-uri), 'headers': map{ 'Accept': 'application/rdf+xml' } }">
                    <xsl:call-template name="onContentLoad">
                        <xsl:with-param name="uri" select="$uri"/>
                        <xsl:with-param name="content-uri" select="$content-uri"/>
                        <xsl:with-param name="container-id" select="$container-id"/>
                        <xsl:with-param name="state" select="$state"/>
                    </xsl:call-template>
                </ixsl:schedule-action>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <!-- load breadcrumbs -->
    
    <xsl:template name="apl:LoadBreadcrumbs">
        <xsl:param name="uri" as="xs:anyURI"/>

        <!-- indirect resource URI, dereferenced through a proxy -->
        <!-- add a bogus query parameter to give the RDF/XML document a different URL in the browser cache, otherwise it will clash with the HTML representation -->
        <!-- this is due to broken browser behavior re. Vary and conditional requests: https://stackoverflow.com/questions/60799116/firefox-if-none-match-headers-ignore-content-type-and-vary/60802443 -->
        <xsl:variable name="request-uri" select="ac:build-uri($ldt:base, map { 'uri': string($uri), 'param': 'dummy' })" as="xs:anyURI"/>

        <ixsl:schedule-action http-request="map{ 'method': 'GET', 'href': $request-uri, 'headers': map{ 'Accept': 'application/rdf+xml' } }">
            <xsl:call-template name="onRDFBodyLoad">
                <xsl:with-param name="uri" select="$uri"/>
            </xsl:call-template>
        </ixsl:schedule-action>
    </xsl:template>
    
    <!-- show "Add data"/"Save as" form -->
    
    <xsl:template name="apl:ShowAddDataForm">
        <xsl:param name="id" select="'add-data'" as="xs:string?"/>
        <xsl:param name="button-class" select="'btn btn-primary btn-save'" as="xs:string?"/>
        <xsl:param name="accept-charset" select="'UTF-8'" as="xs:string?"/>
        <xsl:param name="source" as="xs:anyURI?"/>
        <xsl:param name="graph" as="xs:anyURI?"/>
        <xsl:param name="container" as="xs:anyURI?"/>
        
        <!-- don't append the div if it's already there -->
        <xsl:if test="not(id($id, ixsl:page()))">
            <xsl:for-each select="ixsl:page()//body">
                <!-- append modal div to body -->
                <xsl:result-document href="?." method="ixsl:append-content">
                    <div class="modal modal-constructor fade in">
                        <xsl:if test="$id">
                            <xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
                        </xsl:if>

                        <div class="modal-header">
                            <button type="button" class="close">&#215;</button>

                            <legend title="Add RDF data">Add RDF data</legend>
                        </div>

                        <div class="modal-body">
                            <div class="tabbable">
                                <ul class="nav nav-tabs">
                                    <li>
                                        <xsl:if test="not($source)">
                                            <xsl:attribute name="class">active</xsl:attribute>
                                        </xsl:if>

                                        <a>Upload file</a>
                                    </li>
                                    <li>
                                        <xsl:if test="$source">
                                            <xsl:attribute name="class">active</xsl:attribute>
                                        </xsl:if>

                                        <a>From URI</a>
                                    </li>
                                </ul>
                                <div class="tab-content">
                                    <div>
                                        <xsl:attribute name="class">tab-pane <xsl:if test="not($source)">active</xsl:if></xsl:attribute>

                                        <form id="form-add-data" method="POST" action="{ac:build-uri(resolve-uri('add', $ldt:base), map{ 'forClass': resolve-uri('admin/model/ontologies/system/', $ldt:base) || '#File' })}" enctype="multipart/form-data">
                                            <xsl:comment>This form uses RDF/POST encoding: http://www.lsrn.org/semweb/rdfpost.html</xsl:comment>
                                            <xsl:call-template name="xhtml:Input">
                                                <xsl:with-param name="name" select="'rdf'"/>
                                                <xsl:with-param name="type" select="'hidden'"/>
                                            </xsl:call-template>

                                            <fieldset>
                                                <input type="hidden" name="sb" value="file"/>
                                                <input type="hidden" name="pu" value="&rdf;type"/>
                                                <input type="hidden" name="ou" value="{resolve-uri('admin/model/ontologies/system/#File', $ldt:base)}"/>

                                                <!-- file title is unused, just needed to pass the apl:File constraints -->
                                                <input type="hidden" name="pu" value="&dct;title"/>
                                                <input id="upload-rdf-title" type="hidden" name="ol" value="RDF upload"/>

                                                <div class="control-group required">
                                                    <input type="hidden" name="pu" value="&dct;format"/>
                                                    <label class="control-label" for="upload-rdf-format">Format</label>
                                                    <div class="controls">
                                                        <select id="upload-rdf-format" name="ol">
                                                            <!--<option value="">[browser-defined]</option>-->
                                                            <optgroup label="RDF triples">
                                                                <option value="text/turtle">Turtle (.ttl)</option>
                                                                <option value="application/n-triples">N-Triples (.nt)</option>
                                                                <option value="application/rdf+xml">RDF/XML (.rdf)</option>
                                                            </optgroup>
                                                            <optgroup label="RDF quads">
                                                                <option value="text/trig">TriG (.trig)</option>
                                                                <option value="application/n-quads">N-Quads (.nq)</option>
                                                            </optgroup>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="control-group required">
                                                    <input type="hidden" name="pu" value="&nfo;fileName"/>
                                                    <label class="control-label" for="upload-rdf-filename">FileName</label>
                                                    <div class="controls">
                                                        <input id="upload-rdf-filename" type="file" name="ol"/>
                                                    </div>
                                                </div>
                                                <div class="control-group required">
                                                    <input type="hidden" name="pu" value="&sd;name"/>
                                                    <label class="control-label" for="upload-rdf-doc">Graph</label>
                                                    <div class="controls">
                                                        <span>
                                                            <input type="text" name="ou" id="upload-rdf-doc" class="resource-typeahead typeahead"/>
                                                            <ul class="resource-typeahead typeahead dropdown-menu" id="ul-upload-rdf-doc" style="display: none;"></ul>
                                                        </span>

                                                        <input type="hidden" class="forClass" value="{resolve-uri('admin/model/ontologies/default/#Container', $ldt:base)}" autocomplete="off"/>
                                                        <input type="hidden" class="forClass" value="{resolve-uri('admin/model/ontologies/default/#Item', $ldt:base)}" autocomplete="off"/>
                                                        <div class="btn-group">
                                                            <button type="button" class="btn dropdown-toggle create-action"></button>
                                                            <ul class="dropdown-menu">
                                                                <li>
                                                                    <button type="button" class="btn add-constructor" title="{resolve-uri('admin/model/ontologies/default/#Container', $ldt:base)}" id="{generate-id()}-upload-rdf-container">
                                                                        <xsl:text>Container</xsl:text>
                                                                        <input type="hidden" class="forClass" value="{resolve-uri('admin/model/ontologies/default/#Container', $ldt:base)}"/>
                                                                    </button>
                                                                    <button type="button" class="btn add-constructor" title="{resolve-uri('admin/model/ontologies/default/#Item', $ldt:base)}" id="{generate-id()}-upload-rdf-item">
                                                                        <xsl:text>Item</xsl:text>
                                                                        <input type="hidden" class="forClass" value="{resolve-uri('admin/model/ontologies/default/#Item', $ldt:base)}"/>
                                                                    </button>
                                                                </li>
                                                            </ul>
                                                        </div>
                                                        <span class="help-inline">Document</span>
                                                    </div>
                                                </div>
                                            </fieldset>

                                            <div class="form-actions modal-footer">
                                                <button type="submit" class="{$button-class}">Save</button>
                                                <button type="button" class="btn btn-close">Close</button>
                                                <button type="reset" class="btn btn-reset">Reset</button>
                                            </div>
                                        </form>
                                    </div>
                                    <div>
                                        <xsl:attribute name="class">tab-pane <xsl:if test="$source">active</xsl:if></xsl:attribute>

                                        <form id="form-clone-data" method="POST" action="{resolve-uri('clone', $ldt:base)}">
                                            <xsl:comment>This form uses RDF/POST encoding: http://www.lsrn.org/semweb/rdfpost.html</xsl:comment>
                                            <xsl:call-template name="xhtml:Input">
                                                <xsl:with-param name="name" select="'rdf'"/>
                                                <xsl:with-param name="type" select="'hidden'"/>
                                            </xsl:call-template>

                                            <fieldset>
                                                <input type="hidden" name="sb" value="clone"/>

                                                <div class="control-group required">
                                                    <input type="hidden" name="pu" value="&dct;source"/>
                                                    <label class="control-label" for="remote-rdf-source">Source</label>
                                                    <div class="controls">
                                                        <input type="text" id="remote-rdf-source" name="ou" class="input-xxlarge">
                                                            <xsl:if test="$source">
                                                                <xsl:attribute name="value">
                                                                    <xsl:value-of select="$source"/>
                                                                </xsl:attribute>
                                                            </xsl:if>
                                                        </input>
                                                        <span class="help-inline">Resource</span>
                                                    </div>
                                                </div>
                                                <div class="control-group required">
                                                    <input type="hidden" name="pu" value="&sd;name"/>
                                                    <label class="control-label" for="remote-rdf-doc">Graph</label>
                                                    <div class="controls">
                                                        <span>
                                                            <input type="text" name="ou" id="remote-rdf-doc" class="resource-typeahead typeahead"/>
                                                            <ul class="resource-typeahead typeahead dropdown-menu" id="ul-upload-rdf-doc" style="display: none;"></ul>
                                                        </span>

                                                        <input type="hidden" class="forClass" value="{resolve-uri('admin/model/ontologies/default/#Container', $ldt:base)}" autocomplete="off"/>
                                                        <input type="hidden" class="forClass" value="{resolve-uri('admin/model/ontologies/default/#Item', $ldt:base)}" autocomplete="off"/>
                                                        <div class="btn-group">
                                                            <button type="button" class="btn dropdown-toggle create-action"></button>
                                                            <ul class="dropdown-menu">
                                                                <li>
                                                                    <button type="button" class="btn add-constructor" title="{resolve-uri('admin/model/ontologies/default/#Container', $ldt:base)}" id="{generate-id()}-remote-rdf-container">
                                                                        <xsl:text>Container</xsl:text>
                                                                        <input type="hidden" class="forClass" value="{resolve-uri('admin/model/ontologies/default/#Container', $ldt:base)}"/>
                                                                    </button>
                                                                </li>
                                                                <li>
                                                                    <button type="button" class="btn add-constructor" title="{resolve-uri('admin/model/ontologies/default/#Item', $ldt:base)}" id="{generate-id()}-remote-rdf-item">
                                                                        <xsl:text>Item</xsl:text>
                                                                        <input type="hidden" class="forClass" value="{resolve-uri('admin/model/ontologies/default/#Item', $ldt:base)}"/>
                                                                    </button>
                                                                </li>
                                                            </ul>
                                                        </div>
                                                        <span class="help-inline">Document</span>
                                                    </div>
                                                </div>
                                            </fieldset>

                                            <div class="form-actions modal-footer">
                                                <button type="submit" class="{$button-class}">Save</button>
                                                <button type="button" class="btn btn-close">Close</button>
                                                <button type="reset" class="btn btn-reset">Reset</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>

                            <div class="alert alert-info">
                                <p>Adding data this way will cause a blocking request, so use it for small amounts of data only (e.g. a few thousands of RDF triples). For larger data, use asynchronous <a href="https://linkeddatahub.com/linkeddatahub/docs/reference/imports/rdf/" target="_blank">RDF imports</a>.</p>
                            </div>
                        </div>
                    </div>
                </xsl:result-document>
                
                <xsl:if test="$container">
                    <!-- fill the container typeahead value, if it's provided -->
                    <ixsl:schedule-action http-request="map{ 'method': 'GET', 'href': $container, 'headers': map{ 'Accept': 'application/rdf+xml' } }">
                        <xsl:call-template name="onTypeaheadResourceLoad">
                            <xsl:with-param name="resource-uri" select="$container"/>
                            <xsl:with-param name="typeahead-span" select="id('remote-rdf-doc', ixsl:page())/.."/>
                        </xsl:call-template>
                    </ixsl:schedule-action>
                </xsl:if>

                <ixsl:set-style name="cursor" select="'default'"/>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <!-- root children list -->
    
    <xsl:template name="apl:RootLoad">
        <xsl:context-item as="map(*)" use="required"/>
        <xsl:param name="id" as="xs:string"/>

        <xsl:choose>
            <xsl:when test="?status = 200 and ?media-type = 'application/rdf+xml'">
                <xsl:for-each select="?body">
                    <xsl:variable name="select-uri" select="key('resources', $ldt:base)/dh:select/@rdf:resource" as="xs:anyURI?"/>
                    <xsl:if test="$select-uri">
                        <ixsl:schedule-action http-request="map{ 'method': 'GET', 'href': $select-uri, 'headers': map{ 'Accept': 'application/rdf+xml' } }">
                            <xsl:call-template name="apl:RootChildrenSelectLoad">
                                <xsl:with-param name="id" select="$id"/>
                                <xsl:with-param name="this-uri" select="$ldt:base"/>
                                <xsl:with-param name="select-uri" select="$select-uri"/>
                                <xsl:with-param name="endpoint" select="$ac:endpoint"/>
                            </xsl:call-template>
                        </ixsl:schedule-action>
                    </xsl:if>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="ixsl:call(ixsl:window(), 'alert', [ ?message ])"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="apl:RootChildrenSelectLoad">
        <xsl:context-item as="map(*)" use="required"/>
        <xsl:param name="id" as="xs:string"/>
        <xsl:param name="this-uri" as="xs:anyURI"/>
        <xsl:param name="select-uri" as="xs:anyURI"/>
        <xsl:param name="endpoint" as="xs:anyURI"/>
        <xsl:variable name="endpoint" select="resolve-uri('sparql', $ldt:base)" as="xs:anyURI"/>
        
        <xsl:choose>
            <xsl:when test="?status = 200 and ?media-type = 'application/rdf+xml'">
                <xsl:for-each select="?body">
                    <xsl:variable name="select" select="key('resources', $select-uri)" as="element()?"/>
                    <xsl:variable name="select-string" select="$select/sp:text" as="xs:string?"/>
                    <xsl:if test="$select-string">
                        <!--turn SELECT into DESCRIBE - no point in using ac:build-describe() as we don't want pagination here--> 
                        <!--TO-DO: use CONSTRUCT to only pull dct:titles?--> 
                        <xsl:variable name="query-string" select="replace($select-string, 'DISTINCT', '')" as="xs:string"/>
                        <xsl:variable name="query-string" select="replace($query-string, 'SELECT', 'DESCRIBE')" as="xs:string"/>
                         <!--set ?this variable value--> 
                        <xsl:variable name="query-string" select="replace($query-string, '\?this', concat('&lt;', $this-uri, '&gt;'))" as="xs:string"/>
                        <xsl:variable name="results-uri" select="ac:build-uri($endpoint, map{ 'query': string($query-string) })" as="xs:anyURI"/>

                        <ixsl:schedule-action http-request="map{ 'method': 'GET', 'href': $results-uri, 'headers': map{ 'Accept': 'application/rdf+xml' } }">
                            <xsl:call-template name="apl:RootChildrenResultsLoad">
                                <xsl:with-param name="id" select="$id"/>
                            </xsl:call-template>
                        </ixsl:schedule-action>
                    </xsl:if>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="ixsl:call(ixsl:window(), 'alert', [ ?message ])"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="apl:RootChildrenResultsLoad">
        <xsl:context-item as="map(*)" use="required"/>
        <xsl:param name="id" as="xs:string"/>

        <xsl:choose>
            <xsl:when test="?status = 200 and ?media-type = 'application/rdf+xml'">
                <xsl:for-each select="?body">
                    <xsl:variable name="results" select="." as="document-node()"/>
                        <xsl:variable name="container-list" as="element()*">
                            <xsl:for-each select="key('resources-by-container', $ldt:base, $results)">
                                <xsl:sort select="ac:label(.)" order="ascending" lang="{$ldt:lang}"/>
                                <xsl:apply-templates select="." mode="bs2:List">
                                    <xsl:with-param name="active" select="starts-with($ac:uri, @rdf:about)"/>
                                </xsl:apply-templates>
                            </xsl:for-each>
                        </xsl:variable>

                        <xsl:result-document href="#{$id}" method="ixsl:replace-content">
                            <xsl:if test="$container-list">
                                <div class="well well-small">
                                    <h2 class="nav-header">
                                        <a href="{$ldt:base}" title="{$ldt:base}">
                                            <xsl:value-of>
                                                <xsl:apply-templates select="key('resources', 'root', document(resolve-uri('static/com/atomgraph/linkeddatahub/xsl/bootstrap/2.3.2/translations.rdf', $ac:contextUri)))" mode="ac:label"/>
                                            </xsl:value-of>
                                        </a>
                                    </h2>
                                    <ul class="nav nav-list">
                                        <xsl:copy-of select="$container-list"/>
                                    </ul>
                                </div>
                            </xsl:if>
                        </xsl:result-document>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:result-document href="#{$id}" method="ixsl:replace-content">
                    <div class="alert alert-block">Error loading root children</div>
                </xsl:result-document>
                <!--<xsl:value-of select="ixsl:call(ixsl:window(), 'alert', [ ?message ])"/>-->
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- breadcrumbs -->
    
    <xsl:template name="apl:BreadCrumbResourceLoad">
        <xsl:context-item as="map(*)" use="required"/>
        <xsl:param name="id" as="xs:string"/>
        <xsl:param name="this-uri" as="xs:anyURI"/>
        <xsl:param name="leaf" as="xs:boolean"/>

        <xsl:choose>
            <xsl:when test="?status = 200 and ?media-type = 'application/rdf+xml'">
                <xsl:for-each select="?body">
                    <xsl:variable name="resource" select="key('resources', $this-uri)" as="element()?"/>
                    <xsl:variable name="parent-uri" select="$resource/sioc:has_container/@rdf:resource | $resource/sioc:has_parent/@rdf:resource" as="xs:anyURI?"/>
                    <xsl:if test="$parent-uri">
                        <ixsl:schedule-action http-request="map{ 'method': 'GET', 'href': $parent-uri, 'headers': map{ 'Accept': 'application/rdf+xml' } }">
                            <xsl:call-template name="apl:BreadCrumbResourceLoad">
                                <xsl:with-param name="id" select="$id"/>
                                <xsl:with-param name="this-uri" select="$parent-uri"/>
                                <xsl:with-param name="leaf" select="$leaf"/>
                            </xsl:call-template>
                        </ixsl:schedule-action>
                    </xsl:if>

                    <!-- append to the breadcrumb list -->
                    <xsl:for-each select="id($id, ixsl:page())/ul">
                        <xsl:variable name="content" select="*" as="element()*"/>
                        <!-- we want to prepend the parent resource to the beginning of the breadcrumb list -->
                        <xsl:result-document href="?." method="ixsl:replace-content">
                            <xsl:apply-templates select="$resource" mode="bs2:BreadCrumbListItem">
                                <xsl:with-param name="leaf" select="$leaf"/>
                            </xsl:apply-templates>
                            
                            <xsl:copy-of select="$content"/>
                        </xsl:result-document>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:result-document href="#{$id}" method="ixsl:replace-content">
                    <p class="alert">Error loading breadcrumbs</p>
                </xsl:result-document>
                <!--<xsl:value-of select="ixsl:call(ixsl:window(), 'alert', [ ?message ])"/>-->
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="*[@rdf:about = $ldt:base]" mode="bs2:BreadCrumbListItem" priority="1">
        <xsl:param name="leaf" select="true()" as="xs:boolean"/>

        <li>
            <xsl:apply-templates select="." mode="apl:logo"/>

            <xsl:apply-templates select="." mode="xhtml:Anchor">
                <xsl:with-param name="id" select="()"/>
            </xsl:apply-templates>

            <xsl:text> </xsl:text>
            
            <div class="btn-group">
                <button class="btn btn-small dropdown-toggle" type="button">
                    <span class="caret"></span>
                </button>

                <ul class="dropdown-menu">
                    <li>
                        <a href="{$ldt:base}charts/" class="charts">Charts</a>
                    </li>
                    <li>
                        <a href="{$ldt:base}files/" class="files">Files</a>
                    </li>
                    <li>
                        <a href="{$ldt:base}geo/" class="geo">Geo</a>
                    </li>
                    <li>
                        <a href="{$ldt:base}imports/" class="imports">Imports</a>
                    </li>
                    <li>
                        <a href="{$ldt:base}latest/" class="latest">Latest</a>
                    </li>
                    <li>
                        <a href="{$ldt:base}services/" class="services">Services</a>
                    </li>
                    <li>
                        <a href="{$ldt:base}queries/" class="queries">Queries</a>
                    </li>
                </ul>
            </div>

            <xsl:if test="not($leaf)">
                <span class="divider">/</span>
            </xsl:if>
        </li>
    </xsl:template>
    
    <xsl:template match="*[@rdf:about]" mode="bs2:BreadCrumbListItem">
        <xsl:param name="leaf" select="true()" as="xs:boolean"/>
        
        <li>
            <xsl:apply-templates select="." mode="apl:logo"/>

            <xsl:apply-templates select="." mode="xhtml:Anchor">
                <xsl:with-param name="id" select="()"/>
            </xsl:apply-templates>

            <xsl:if test="not($leaf)">
                <span class="divider">/</span>
            </xsl:if>
        </li>
    </xsl:template>

    <!-- chart -->
    
    <xsl:template name="onChartServiceLoad">
        <xsl:context-item as="map(*)" use="required"/>
        <xsl:param name="service-uri" as="xs:anyURI"/>
        <xsl:param name="query-string" as="xs:string"/>
        <xsl:param name="chart-type" as="xs:anyURI"/>
        <xsl:param name="category" as="xs:string?"/>
        <xsl:param name="series" as="xs:string*"/>
        
        <xsl:choose>
            <xsl:when test="?status = 200 and ?media-type = 'application/rdf+xml'">
                <xsl:for-each select="?body">
                    <xsl:variable name="service" select="key('resources', $service-uri)" as="element()"/>
                    <xsl:variable name="endpoint" select="xs:anyURI(($service/sd:endpoint/@rdf:resource, (if ($service/dydra:repository/@rdf:resource) then ($service/dydra:repository/@rdf:resource || 'sparql') else ()))[1])" as="xs:anyURI"/>

                    <xsl:variable name="results-uri" select="ac:build-uri($endpoint, let $params := map{ 'query': $query-string } return if ($service/dydra-urn:accessToken) then map:merge(($params, map{ 'auth_token': $service/dydra-urn:accessToken })) else $params)" as="xs:anyURI"/>
                    
                    <ixsl:schedule-action http-request="map{ 'method': 'GET', 'href': $results-uri, 'headers': map{ 'Accept': 'application/sparql-results+xml,application/rdf+xml;q=0.9' } }">
                        <xsl:call-template name="onSPARQLResultsLoad">
                            <xsl:with-param name="container-id" select="'sparql-results'"/>
                            <xsl:with-param name="chart-type" select="$chart-type"/>
                            <xsl:with-param name="category" select="$category"/>
                            <xsl:with-param name="series" select="$series"/>
                        </xsl:call-template>
                    </ixsl:schedule-action>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="ixsl:call(ixsl:window(), 'alert', [ ?message ])"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="onChartQueryLoad">
        <xsl:context-item as="map(*)" use="required"/>
        <xsl:param name="query-uri" as="xs:anyURI"/>
        <xsl:param name="chart-type" as="xs:anyURI"/>
        <xsl:param name="category" as="xs:string?"/>
        <xsl:param name="series" as="xs:string*"/>
        
        <xsl:variable name="response" select="." as="map(*)"/>
        <xsl:choose>
            <xsl:when test="?status = 200 and ?media-type = ('application/rdf+xml', 'application/sparql-results+xml')">
                <xsl:for-each select="?body">
                    <xsl:variable name="query-type" select="xs:anyURI(key('resources', $query-uri)/rdf:type/@rdf:resource)" as="xs:anyURI"/>
                    <xsl:variable name="query-string" select="key('resources', $query-uri)/sp:text" as="xs:string"/>
                    <!-- TO-DO: use SPARQLBuilder to set LIMIT -->
                    <!--<xsl:variable name="query-string" select="concat($query-string, ' LIMIT 100')" as="xs:string"/>-->
                    <xsl:variable name="service-uri" select="xs:anyURI(key('resources', $query-uri)/apl:service/@rdf:resource)" as="xs:anyURI?"/>

                    <!--<ixsl:set-style name="display" select="'none'" object="id($container-id, ixsl:page())//div[@class = 'bar']"/>-->

                    <xsl:result-document href="#main-content" method="ixsl:append-content">
                        <div id="sparql-results"/>
                    </xsl:result-document>

                    <xsl:choose>
                        <xsl:when test="$service-uri">
                            <ixsl:schedule-action http-request="map{ 'method': 'GET', 'href': $service-uri, 'headers': map{ 'Accept': 'application/rdf+xml' } }">
                                <xsl:call-template name="onChartServiceLoad">
                                    <xsl:with-param name="service-uri" select="$service-uri"/>
                                    <xsl:with-param name="query-string" select="$query-string"/>
                                    <xsl:with-param name="chart-type" select="$chart-type"/>
                                    <xsl:with-param name="category" select="$category"/>
                                    <xsl:with-param name="series" select="$series"/>
                                </xsl:call-template>
                            </ixsl:schedule-action>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:variable name="endpoint" select="$ac:endpoint" as="xs:anyURI"/>
                            <xsl:variable name="results-uri" select="ac:build-uri($endpoint, map{ 'query': string($query-string) })" as="xs:anyURI"/>
                            
                            <ixsl:schedule-action http-request="map{ 'method': 'GET', 'href': $results-uri, 'headers': map{ 'Accept': 'application/sparql-results+xml,application/rdf+xml;q=0.9' } }">
                                <xsl:call-template name="onSPARQLResultsLoad">
                                    <xsl:with-param name="container-id" select="'sparql-results'"/>
                                    <xsl:with-param name="chart-type" select="$chart-type"/>
                                    <xsl:with-param name="category" select="$category"/>
                                    <xsl:with-param name="series" select="$series"/>
                                </xsl:call-template>
                            </ixsl:schedule-action>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <!--<ixsl:set-style name="display" select="'none'" object="id($container-id, ixsl:page())//div[@class = 'bar']"/>-->
        
                <!-- error response - could not load query results -->
                <xsl:result-document href="#sparql-results" method="ixsl:replace-content">
                    <div class="alert alert-block">
                        <strong>Error during query execution:</strong>
                        <pre>
                            <xsl:value-of select="$response?message"/>
                        </pre>
                    </div>
                </xsl:result-document>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="onSPARQLResultsLoad">
        <xsl:context-item as="map(*)" use="required"/>
        <xsl:param name="content-uri" as="xs:anyURI"/>
        <xsl:param name="container-id" as="xs:string"/>
        <xsl:param name="chart-canvas-id" select="$container-id || '-chart-canvas'" as="xs:string"/>
        <xsl:param name="chart-type" select="xs:anyURI('&ac;Table')" as="xs:anyURI"/>
        <xsl:param name="category" as="xs:string?"/>
        <xsl:param name="series" as="xs:string*"/>
        
        <xsl:variable name="response" select="." as="map(*)"/>
        <xsl:choose>
            <xsl:when test="?status = 200 and ?media-type = ('application/rdf+xml', 'application/sparql-results+xml')">
                <xsl:for-each select="?body">
                    <xsl:variable name="results" select="." as="document-node()"/>
                    <xsl:variable name="category" select="if ($category) then $category else (if (rdf:RDF) then distinct-values(rdf:RDF/*/*/concat(namespace-uri(), local-name()))[1] else srx:sparql/srx:head/srx:variable[1]/@name)" as="xs:string?"/>
                    <xsl:variable name="series" select="if ($series) then $series else (if (rdf:RDF) then distinct-values(rdf:RDF/*/*/concat(namespace-uri(), local-name())) else srx:sparql/srx:head/srx:variable/@name)" as="xs:string*"/>

                    <ixsl:set-style name="cursor" select="'default'" object="ixsl:page()//body"/>

                    <xsl:result-document href="#{$container-id}" method="ixsl:replace-content">
                        <xsl:apply-templates select="$results" mode="bs2:Chart">
                            <xsl:with-param name="canvas-id" select="$chart-canvas-id"/>
                            <xsl:with-param name="chart-type" select="$chart-type"/>
                            <xsl:with-param name="category" select="$category"/>
                            <xsl:with-param name="series" select="$series"/>
                        </xsl:apply-templates>
                    </xsl:result-document>

                    <!-- create new cache entry using content URI as key -->
                    <ixsl:set-property name="{$content-uri}" select="ac:new-object()" object="ixsl:get(ixsl:window(), 'LinkedDataHub')"/>
                    <ixsl:set-property name="results" select="$results" object="ixsl:get(ixsl:get(ixsl:window(), 'LinkedDataHub'), $content-uri)"/>
                    <xsl:variable name="data-table" select="if ($results/rdf:RDF) then ac:rdf-data-table($results, $category, $series) else ac:sparql-results-data-table($results, $category, $series)"/>
                    <ixsl:set-property name="data-table" select="$data-table" object="ixsl:get(ixsl:get(ixsl:window(), 'LinkedDataHub'), $content-uri)"/>
            
                    <xsl:call-template name="render-chart">
                        <xsl:with-param name="data-table" select="$data-table"/>
                        <xsl:with-param name="canvas-id" select="$chart-canvas-id"/>
                        <xsl:with-param name="chart-type" select="$chart-type"/>
                        <xsl:with-param name="category" select="$category"/>
                        <xsl:with-param name="series" select="$series"/>
                    </xsl:call-template>

                    <xsl:call-template name="apl:PushState">
                        <xsl:with-param name="href" select="$content-uri"/>
                    </xsl:call-template>

                    <xsl:for-each select="ixsl:page()//div[tokenize(@class, ' ') = 'action-bar']">
                        <!-- disable 'btn-save-as' if the result is not RDF (e.g. SPARQL XML results), enable otherwise -->
                        <xsl:sequence select="ixsl:call(ixsl:get(.//button[tokenize(@class, ' ') = 'btn-save-as'], 'classList'), 'toggle', [ 'disabled', not($results/rdf:RDF) ])[current-date() lt xs:date('2000-01-01')]"/>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <!-- remove query progress bar -->
                <!--<xsl:result-document href="#progress-bar" method="ixsl:replace-content"></xsl:result-document>-->
        
                <!-- error response - could not load query results -->
                <xsl:result-document href="#{$container-id}" method="ixsl:replace-content">
                    <div class="alert alert-block">
                        <strong>Error during query execution:</strong>
                        <pre>
                            <xsl:value-of select="$response?message"/>
                        </pre>
                    </div>
                </xsl:result-document>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="render-chart">
        <xsl:param name="data-table"/>
        <xsl:param name="canvas-id" as="xs:string"/>
        <xsl:param name="chart-type" as="xs:anyURI"/>
        <xsl:param name="category" as="xs:string?"/>
        <xsl:param name="series" as="xs:string*"/>
        
<!--        <xsl:if test="id('progress-bar', ixsl:page())">
             remove query progress bar 
            <xsl:result-document href="#progress-bar" method="ixsl:replace-content"/>
        </xsl:if>-->
        
        <xsl:call-template name="ac:draw-chart">
            <xsl:with-param name="data-table" select="$data-table"/>
            <xsl:with-param name="canvas-id" select="$canvas-id"/>
            <xsl:with-param name="chart-type" select="$chart-type"/>
            <xsl:with-param name="category" select="$category"/>
            <xsl:with-param name="series" select="$series"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- render dropdown from SPARQL service results -->
    
    <xsl:template name="onServiceLoad">
        <xsl:context-item as="map(*)" use="required"/>
        <xsl:param name="service-select" as="element()?"/>
        <xsl:param name="selected-service" as="xs:anyURI?"/>

        <xsl:choose>
            <xsl:when test="?status = 200 and ?media-type = 'application/rdf+xml'">
                <xsl:for-each select="?body">
                    <xsl:variable name="results" select="." as="document-node()"/>
                    <ixsl:set-property name="services" select="$results" object="ixsl:get(ixsl:window(), 'LinkedDataHub')"/>
                    
                    <xsl:for-each select="$service-select">
                        <xsl:result-document href="?." method="ixsl:append-content">
                            <xsl:for-each select="$results//*[@rdf:about]">
                                <xsl:sort select="ac:label(.)"/>

                                <xsl:apply-templates select="." mode="xhtml:Option">
                                    <xsl:with-param name="value" select="@rdf:about"/>
                                    <xsl:with-param name="selected" select="@rdf:about = $selected-service"/>
                                </xsl:apply-templates>
                            </xsl:for-each>
                        </xsl:result-document>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="ixsl:call(ixsl:get(ixsl:window(), 'console'), 'log', [ ?message ])"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- embed content -->
    
    <xsl:template name="onContentLoad">
        <xsl:context-item as="map(*)" use="required"/>
        <xsl:param name="uri" as="xs:anyURI"/>
        <xsl:param name="content-uri" as="xs:anyURI?"/>
        <xsl:param name="container-id" as="xs:string"/>
        <xsl:param name="state" as="item()?"/>

        <xsl:choose>
            <xsl:when test="?status = 200 and ?media-type = 'application/rdf+xml'">
                <!-- update progress bar -->
                <ixsl:set-style name="width" select="'50%'" object="id($container-id, ixsl:page())//div[@class = 'bar']"/>
            
                <xsl:apply-templates select="key('resources', $content-uri, ?body)" mode="apl:Content">
                    <xsl:with-param name="uri" select="$uri"/>
                    <xsl:with-param name="container-id" select="$container-id"/>
                    <xsl:with-param name="state" select="$state"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="ixsl:call(ixsl:get(ixsl:window(), 'console'), 'log', [ ?message ])"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Linked Data browser -->
    
    <xsl:template name="onDocumentLoad">
        <xsl:context-item as="map(*)" use="required"/>
        <xsl:param name="uri" as="xs:anyURI?"/>
        <xsl:param name="fragment" as="xs:string?"/>
        <xsl:param name="container-id" select="'content-body'" as="xs:string"/>
        <xsl:param name="fallback" select="false()" as="xs:boolean"/>
        <xsl:param name="service-uri" select="xs:anyURI(ixsl:get(id('search-service', ixsl:page()), 'value'))" as="xs:anyURI?"/>
        <xsl:param name="service" select="key('resources', $service-uri, ixsl:get(ixsl:window(), 'LinkedDataHub.services'))" as="element()?"/>
        <xsl:param name="state" as="item()?"/>
        <xsl:param name="push-state" select="true()" as="xs:boolean"/>
        
        <xsl:variable name="response" select="." as="map(*)"/>
        <xsl:choose>
            <xsl:when test="?status = 200 and ?media-type = 'application/xhtml+xml'">
                <xsl:apply-templates select="?body" mode="apl:Document">
                    <xsl:with-param name="uri" select="$uri"/>
                    <xsl:with-param name="fragment" select="$fragment"/>
                    <xsl:with-param name="container-id" select="$container-id"/>
                    <xsl:with-param name="state" select="$state"/>
                    <xsl:with-param name="push-state" select="$push-state"/>
                </xsl:apply-templates>
            </xsl:when>
            <!-- we want to fall back from unsuccessful Linked Data request to SPARQL DESCRIBE query but prevent it from looping forever -->
            <xsl:when test="(?status = (500, 502)) and $service and not($fallback)">
                <xsl:variable name="endpoint" select="xs:anyURI(($service/sd:endpoint/@rdf:resource, (if ($service/dydra:repository/@rdf:resource) then ($service/dydra:repository/@rdf:resource || 'sparql') else ()))[1])" as="xs:anyURI"/>
                <xsl:variable name="query-string" select="'DESCRIBE &lt;' || $uri || '&gt;'" as="xs:string"/>
                <xsl:variable name="results-uri" select="ac:build-uri($endpoint, let $params := map{ 'query': $query-string } return if ($service/dydra-urn:accessToken) then map:merge(($params, map{ 'auth_token': $service/dydra-urn:accessToken })) else $params)" as="xs:anyURI"/>

                <ixsl:set-style name="cursor" select="'progress'" object="ixsl:page()//body"/>
                <ixsl:schedule-action http-request="map{ 'method': 'GET', 'href': $results-uri, 'headers': map{ 'Accept': 'application/xhtml+xml' } }">
                    <xsl:call-template name="onDocumentLoad">
                        <xsl:with-param name="uri" select="$uri"/>
                        <xsl:with-param name="fallback" select="true()"/>
                    </xsl:call-template>
                </ixsl:schedule-action>
            </xsl:when>
            <xsl:otherwise>
                <ixsl:set-style name="cursor" select="'default'" object="ixsl:page()//body"/>
                
                <!-- error response - could not load query results -->
                <xsl:result-document href="#content-body" method="ixsl:replace-content">
                    <div class="alert alert-block">
                        <strong>Error loading RDF document:</strong>
                        <pre>
                            <xsl:value-of select="$response?message"/>
                        </pre>
                    </div>
                </xsl:result-document>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="/" mode="apl:Document">
        <xsl:param name="uri" as="xs:anyURI?"/>
        <xsl:param name="fragment" as="xs:string?"/>
        <xsl:param name="container-id" select="'content-body'" as="xs:string"/>
        <xsl:param name="state" as="item()?"/>
        <xsl:param name="push-state" select="true()" as="xs:boolean"/>

        <xsl:message>Loaded document with URI: <xsl:value-of select="$uri"/> fragment: <xsl:value-of select="$fragment"/></xsl:message>

        <ixsl:set-style name="cursor" select="'default'" object="ixsl:page()//body"/>
        <xsl:for-each select="ixsl:page()//div[tokenize(@class, ' ') = 'action-bar']">
            <!-- deactivate .btn-edit -->
            <xsl:sequence select="ixsl:call(ixsl:get(.//button[tokenize(@class, ' ') = 'btn-edit'], 'classList'), 'toggle', [ 'active', false() ])[current-date() lt xs:date('2000-01-01')]"/>
            <!-- enable .btn-save-as -->
            <xsl:sequence select="ixsl:call(ixsl:get(.//button[tokenize(@class, ' ') = 'btn-save-as'], 'classList'), 'toggle', [ 'disabled', false() ])[current-date() lt xs:date('2000-01-01')]"/>
        </xsl:for-each>

        <ixsl:set-property name="href" select="$uri" object="ixsl:get(ixsl:window(), 'LinkedDataHub')"/>
        <xsl:choose>
            <xsl:when test="starts-with($uri, $ldt:base)">
                <ixsl:set-property name="local-href" select="$uri" object="ixsl:get(ixsl:window(), 'LinkedDataHub')"/>
                <!-- unset #uri value -->
                <xsl:for-each select="id('uri', ixsl:page())">
                    <ixsl:set-property name="value" select="()" object="."/>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <!-- set #uri value -->
                <xsl:for-each select="id('uri', ixsl:page())">
                    <ixsl:set-property name="value" select="$uri" object="."/>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>

        <xsl:if test="$push-state">
            <xsl:call-template name="apl:PushState">
                <xsl:with-param name="href" select="ac:build-uri($ldt:base, map{ 'uri': string($uri) })"/>
                <xsl:with-param name="title" select="title"/>
            </xsl:call-template>
        </xsl:if>

        <!-- set document.title which history.pushState() does not do -->
        <ixsl:set-property name="title" select="substring-before(ixsl:page()/html/head/title, ' -') || ' - ' || html/head/title" object="ixsl:page()"/>

        <xsl:variable name="results" select="." as="document-node()"/>
        <!-- replace content body with the loaded XHTML -->
        <xsl:result-document href="#{$container-id}" method="ixsl:replace-content">
            <xsl:copy-of select="id($container-id, $results)/*"/>
        </xsl:result-document>

        <xsl:choose>
            <!-- scroll fragment-identified element into view if fragment is provided-->
            <xsl:when test="id($fragment, ixsl:page())">
                <xsl:for-each select="id($fragment, ixsl:page())">
                    <xsl:sequence select="ixsl:call(., 'scrollIntoView', [])[current-date() lt xs:date('2000-01-01')]"/>
                </xsl:for-each >
            </xsl:when>
            <!-- otherwise, scroll to the top of the window -->
            <xsl:otherwise>
                <xsl:sequence select="ixsl:call(ixsl:window(), 'scrollTo', [ 0, 0 ])[current-date() lt xs:date('2000-01-01')]"/>
            </xsl:otherwise>
        </xsl:choose>

        <!-- update RDF download links to match the current URI -->
        <xsl:for-each select="id('export-rdf', ixsl:page())/following-sibling::ul/li/a">
            <xsl:variable name="local-uri" select="xs:anyURI(ixsl:get(ixsl:window(), 'LinkedDataHub.local-href'))" as="xs:anyURI"/>
            <!-- use @title attribute for the media type TO-DO: find a better way, a hidden input or smth -->
            <xsl:variable name="href" select="ac:build-uri($local-uri, let $params := map{ 'accept': string(@title) } return if (not(starts-with($local-uri, $ldt:base))) then map:merge(($params, map{ 'uri': $local-uri})) else $params)" as="xs:anyURI"/>
            <ixsl:set-property name="href" select="$href" object="."/>
        </xsl:for-each>

        <xsl:variable name="content-ids" select="key('elements-by-class', 'resource-content', $results)/@id" as="xs:string*"/>
        <xsl:call-template name="apl:LoadContents">
            <xsl:with-param name="uri" select="$uri"/>
            <xsl:with-param name="content-ids" select="$content-ids"/>
            <xsl:with-param name="state" select="$state"/>
        </xsl:call-template>

        <xsl:call-template name="apl:LoadBreadcrumbs">
            <xsl:with-param name="uri" select="$uri"/>
        </xsl:call-template>

<!--                    <xsl:if test="key('resources', $uri) and id('breadcrumb-nav', ixsl:page())">
            <xsl:variable name="resource" select="key('resources', $uri)" as="element()"/>

            <xsl:result-document href="#breadcrumb-nav" method="ixsl:replace-content">
                <ul class="breadcrumb pull-left">
                    <xsl:apply-templates select="$resource" mode="bs2:BreadCrumbListItem">
                        <xsl:with-param name="leaf" select="true()"/>
                    </xsl:apply-templates>
                </ul>
                <span class="label label-info pull-left">External</span>
            </xsl:result-document>

            <xsl:result-document href="#result-counts" method="ixsl:replace-content"/>
        </xsl:if>-->
    </xsl:template>
    
    <!-- EVENT LISTENERS -->

    <!-- popstate -->
    
    <xsl:template match="." mode="ixsl:onpopstate">
        <xsl:variable name="state" select="ixsl:get(ixsl:event(), 'state')"/>
        <xsl:variable name="content-uri" select="map:get($state, '&apl;content')" as="xs:anyURI?"/>
        <xsl:variable name="href" select="map:get($state, 'href')" as="xs:anyURI?"/>

        <ixsl:set-style name="cursor" select="'progress'" object="ixsl:page()//body"/>

        <!-- decode URI from the ?uri query param which is used in apl:PushState -->
        <xsl:variable name="uri" select="if ($content-uri) then $href else xs:anyURI(ixsl:call(ixsl:window(), 'decodeURIComponent', [ substring-after($href, '?uri=') ]))" as="xs:anyURI"/>
        <xsl:message>
            onpopstate $content-uri: <xsl:value-of select="$content-uri"/> $href: <xsl:value-of select="$href"/> $uri: <xsl:value-of select="$uri"/> 
        </xsl:message>
        
        <ixsl:schedule-action http-request="map{ 'method': 'GET', 'href': $href, 'headers': map{ 'Accept': 'application/xhtml+xml' } }">
            <xsl:call-template name="onDocumentLoad">
                <xsl:with-param name="uri" select="$uri"/>
                <xsl:with-param name="state" select="$state"/>
                <!-- we don't want to push the same state we just popped back to -->
                <xsl:with-param name="push-state" select="false()"/>
            </xsl:call-template>
        </ixsl:schedule-action>
    </xsl:template>
    
    <!-- intercept all link HTTP(S) clicks except those in the navbar (except breadcrumb bar) and the footer -->
    <xsl:template match="a[not(@target)][starts-with(@href, 'http://') or starts-with(@href, 'https://')][ancestor::div[@id = 'breadcrumb-nav'] or not(ancestor::div[tokenize(@class, ' ') = ('navbar', 'footer')])]" mode="ixsl:onclick">
        <xsl:sequence select="ixsl:call(ixsl:event(), 'preventDefault', [])"/>
        <xsl:variable name="uri" select="xs:anyURI(@href)" as="xs:anyURI"/>
        <!-- indirect resource URI, dereferenced through a proxy -->
        <xsl:variable name="request-uri" select="ac:build-uri($ldt:base, map{ 'uri': string($uri) })" as="xs:anyURI"/>
        
        <ixsl:set-style name="cursor" select="'progress'" object="ixsl:page()//body"/>
        
        <ixsl:schedule-action http-request="map{ 'method': 'GET', 'href': $request-uri, 'headers': map{ 'Accept': 'application/xhtml+xml' } }">
            <xsl:call-template name="onDocumentLoad">
                <xsl:with-param name="uri" select="ac:document-uri($uri)"/>
                <xsl:with-param name="fragment" select="encode-for-uri($uri)"/>
            </xsl:call-template>
        </ixsl:schedule-action>
    </xsl:template>
    
    <xsl:template match="form[tokenize(@class, ' ') = 'navbar-form']" mode="ixsl:onsubmit">
        <xsl:sequence select="ixsl:call(ixsl:event(), 'preventDefault', [])"/>
        <xsl:variable name="uri-string" select=".//input[@name = 'uri']/ixsl:get(., 'value')" as="xs:string?"/>
        
        <xsl:if test="$uri-string castable as xs:anyURI and (starts-with($uri-string, 'http://') or starts-with($uri-string, 'https://'))">
            <xsl:variable name="uri" select="xs:anyURI($uri-string)" as="xs:anyURI"/>
            <!-- indirect resource URI, dereferenced through a proxy -->
            <xsl:variable name="request-uri" select="ac:build-uri($ldt:base, map { 'uri': string($uri) })" as="xs:anyURI"/>
            
            <ixsl:set-style name="cursor" select="'progress'" object="ixsl:page()//body"/>

            <ixsl:schedule-action http-request="map{ 'method': 'GET', 'href': $request-uri, 'headers': map{ 'Accept': 'application/xhtml+xml' } }">
                <xsl:call-template name="onDocumentLoad">
                    <xsl:with-param name="uri" select="ac:document-uri($uri)"/>
                    <xsl:with-param name="fragment" select="encode-for-uri($uri)"/>
                </xsl:call-template>
            </ixsl:schedule-action>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="form[tokenize(@class, ' ') = 'form-horizontal'] | form[ancestor::div[tokenize(@class, ' ') = 'modal']]" mode="ixsl:onsubmit">
        <xsl:sequence select="ixsl:call(ixsl:event(), 'preventDefault', [])"/>
        <xsl:variable name="form" select="." as="element()"/>
        <xsl:variable name="id" select="ixsl:get(., 'id')" as="xs:string"/>
        <xsl:variable name="method" select="ixsl:get(., 'method')" as="xs:string"/>
        <xsl:variable name="action" select="ixsl:get(., 'action')" as="xs:anyURI"/>
        <xsl:variable name="enctype" select="ixsl:get(., 'enctype')" as="xs:string"/>
        <xsl:variable name="accept" select="'application/xhtml+xml'" as="xs:string"/>

        <ixsl:set-style name="cursor" select="'progress'" object="ixsl:page()//body"/>
        
        <!-- remove names of RDF/POST inputs with empty values -->
        <xsl:for-each select=".//input[@name = ('ob', 'ou', 'ol')][not(ixsl:get(., 'value'))]">
            <ixsl:remove-attribute name="name"/>
        </xsl:for-each>
        
        <!-- TO-DO: override $action with the sioc:has_container/sioc:has_parent typeahead value? -->

        <xsl:choose>
            <!-- we need to handle multipart requests specially because of Saxon-JS 2 limitations: https://saxonica.plan.io/issues/4732 -->
            <xsl:when test="$enctype = 'multipart/form-data'">
                <xsl:variable name="js-statement" as="element()">
                    <root statement="new FormData(document.getElementById('{$id}'))"/>
                </xsl:variable>
                <xsl:variable name="form-data" select="ixsl:eval(string($js-statement/@statement))"/>
                <xsl:variable name="js-statement" as="element()">
                    <root statement="{{ 'Accept': '{$accept}' }}"/>
                </xsl:variable>
                <xsl:variable name="headers" select="ixsl:eval(string($js-statement/@statement))"/>
                
                <xsl:sequence select="js:fetchDispatchXML($action, $method, $headers, $form-data, ., 'multipartFormLoad')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="js-statement" as="element()">
                    <root statement="new URLSearchParams(new FormData(document.getElementById('{$id}')))"/>
                </xsl:variable>
                <xsl:variable name="form-data" select="ixsl:eval(string($js-statement/@statement))"/>

                <ixsl:schedule-action http-request="map{ 'method': $method, 'href': $action, 'media-type': $enctype, 'body': $form-data, 'headers': map{ 'Accept': $accept } }">
                    <xsl:call-template name="onFormLoad">
                        <xsl:with-param name="action" select="$action"/>
                        <xsl:with-param name="form" select="$form"/>
                        <xsl:with-param name="target-id" select="$form/input[@class = 'target-id']/@value"/>
                    </xsl:call-template>
                </ixsl:schedule-action>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- the same logic as onFormLoad but handles only responses to multipart requests invoked via JS function fetchDispatchXML() -->
    <xsl:template match="." mode="ixsl:onmultipartFormLoad">
        <xsl:param name="container-id" select="'content-body'" as="xs:string"/>
        <xsl:variable name="event" select="ixsl:event()"/>
        <xsl:variable name="action" select="ixsl:get(ixsl:get($event, 'detail'), 'action')" as="xs:anyURI"/>
        <xsl:variable name="form" select="ixsl:get(ixsl:get($event, 'detail'), 'target')" as="element()"/> <!-- not ixsl:get(ixsl:event(), 'target') because that's the whole document -->
        <xsl:variable name="target-id" select="$form/input[@class = 'target-id']/@value" as="xs:string?"/>
        <!-- $target-id is of the "Create" button, need to replace the preceding typeahead input instead -->
        <xsl:variable name="typeahead-span" select="if ($target-id) then id($target-id, ixsl:page())/ancestor::div[@class = 'controls']//span[descendant::input[@name = 'ou']] else ()" as="element()?"/>
        <xsl:variable name="response" select="ixsl:get(ixsl:get($event, 'detail'), 'response')"/>
        <xsl:variable name="html" select="if (ixsl:contains($event, 'detail.xml')) then ixsl:get($event, 'detail.xml') else ()" as="document-node()?"/>

        <xsl:choose>
            <!-- special case for add/clone data forms: redirect to the container -->
            <xsl:when test="ixsl:get($form, 'id') = ('form-add-data', 'form-clone-data')">
                <xsl:variable name="control-group" select="$form/descendant::div[tokenize(@class, ' ') = 'control-group'][input[@name = 'pu'][@value = '&sd;name']]" as="element()*"/>
                <xsl:variable name="uri" select="$control-group/descendant::input[@name = 'ou']/ixsl:get(., 'value')" as="xs:anyURI"/>
                <!-- load document -->
                <ixsl:schedule-action http-request="map{ 'method': 'GET', 'href': $uri, 'headers': map{ 'Accept': 'application/xhtml+xml' } }">
                    <xsl:call-template name="onDocumentLoad">
                        <xsl:with-param name="uri" select="ac:document-uri($uri)"/>
                        <xsl:with-param name="fragment" select="encode-for-uri($uri)"/>
                    </xsl:call-template>
                </ixsl:schedule-action>
                <!-- remove the modal div -->
                <xsl:sequence select="ixsl:call($form/ancestor::div[tokenize(@class, ' ') = 'modal'], 'remove', [])[current-date() lt xs:date('2000-01-01')]"/>
            </xsl:when>
            <xsl:when test="ixsl:get($response, 'status') = 200">
                <!-- trim the query string if it's present -->
                <xsl:variable name="uri" select="if (contains($action, '?')) then xs:anyURI(substring-before($action, '?')) else $action" as="xs:anyURI"/>
                <!-- reload resource -->
                <ixsl:schedule-action http-request="map{ 'method': 'GET', 'href': $uri, 'headers': map{ 'Accept': 'application/xhtml+xml' } }">
                    <xsl:call-template name="onDocumentLoad">
                        <xsl:with-param name="uri" select="ac:document-uri($uri)"/>
                        <xsl:with-param name="fragment" select="encode-for-uri($uri)"/>
                    </xsl:call-template>
                </ixsl:schedule-action>
            </xsl:when>
            <!-- POST created new resource successfully -->
            <xsl:when test="ixsl:get($response, 'status') = 201 and ixsl:call(ixsl:get($response, 'headers'), 'has', [ 'Location' ])">
                <xsl:variable name="created-uri" select="ixsl:call(ixsl:get($response, 'headers'), 'get', [ 'Location' ])" as="xs:anyURI"/>
                        
                <xsl:choose>
                    <!-- if form submit did not originate from a typeahead (target), load the created resource -->
                    <xsl:when test="not($typeahead-span)">
                        <ixsl:schedule-action http-request="map{ 'method': 'GET', 'href': $created-uri, 'headers': map{ 'Accept': 'application/xhtml+xml' } }">
                            <xsl:call-template name="onDocumentLoad">
                                <xsl:with-param name="uri" select="ac:document-uri($created-uri)"/>
                                <xsl:with-param name="fragment" select="encode-for-uri($created-uri)"/>
                            </xsl:call-template>
                        </ixsl:schedule-action>
                    </xsl:when>
                    <!-- otherwise, render the created resource as a typeahead input -->
                    <xsl:otherwise>
                        <ixsl:schedule-action http-request="map{ 'method': 'GET', 'href': $created-uri, 'headers': map{ 'Accept': 'application/rdf+xml' } }">
                            <xsl:call-template name="onTypeaheadResourceLoad">
                                <xsl:with-param name="resource-uri" select="$created-uri"/>
                                <xsl:with-param name="typeahead-span" select="$typeahead-span"/>
                                <xsl:with-param name="modal-form" select="$form"/>
                            </xsl:call-template>
                        </ixsl:schedule-action>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="ixsl:get($response, 'status') = 400 and $html">
                <xsl:variable name="form-id" select="ixsl:get($form, 'id')" as="xs:string"/>
                
                <xsl:for-each select="$html">
                    <xsl:variable name="doc-id" select="concat('id', ixsl:call(ixsl:window(), 'generateUUID', []))" as="xs:string"/>
                    <xsl:variable name="form" as="element()">
                        <xsl:apply-templates select="//form[@class = 'form-horizontal']" mode="form">
                            <xsl:with-param name="target-id" select="$target-id" tunnel="yes"/>
                            <xsl:with-param name="doc-id" select="$doc-id" tunnel="yes"/>
                        </xsl:apply-templates>
                    </xsl:variable>

<!--                    <xsl:result-document href="#{$form-id}" method="ixsl:replace-content">
                        <xsl:copy-of select="$form/*"/>
                    </xsl:result-document>-->
                    <xsl:result-document href="#{$container-id}" method="ixsl:replace-content">
                        <div class="row-fluid">
                            <div class="left-nav span2"></div>

                            <div class="span7">
                                <xsl:copy-of select="$form"/>
                            </div>
                        </div>
                    </xsl:result-document>
                    
                    <xsl:call-template name="add-form-listeners">
                        <xsl:with-param name="id" select="$form-id"/>
                    </xsl:call-template>
                    
                    <ixsl:set-style name="cursor" select="'default'" object="ixsl:page()//body"/>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="ixsl:call(ixsl:window(), 'alert', [ ixsl:get($response, 'statusText') ])"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- after form is submitted. TO-DO: split into multiple callbacks and avoid <xsl:choose>? -->
    <xsl:template name="onFormLoad">
        <xsl:context-item as="map(*)" use="required"/>
        <xsl:param name="container-id" select="'content-body'" as="xs:string"/>
        <xsl:param name="action" as="xs:anyURI"/>
        <xsl:param name="form" as="element()"/>
        <xsl:param name="target-id" as="xs:string?"/>
        <!-- $target-id is of the "Create" button, need to replace the preceding typeahead input instead -->
        <xsl:param name="typeahead-span" select="if ($target-id) then id($target-id, ixsl:page())/ancestor::div[@class = 'controls']//span[descendant::input[@name = 'ou']] else ()" as="element()?"/>

        <xsl:message>
            Form loaded with ?status <xsl:value-of select="?status"/> $target-id: <xsl:value-of select="$target-id"/>
        </xsl:message>
        
        <xsl:choose>
            <!-- special case for add/clone data forms: redirect to the container -->
            <xsl:when test="ixsl:get($form, 'id') = ('form-add-data', 'form-clone-data')">
                <xsl:variable name="control-group" select="$form/descendant::div[tokenize(@class, ' ') = 'control-group'][input[@name = 'pu'][@value = '&sd;name']]" as="element()*"/>
                <xsl:variable name="uri" select="$control-group/descendant::input[@name = 'ou']/ixsl:get(., 'value')" as="xs:anyURI"/>
                <!-- load document -->
                <ixsl:schedule-action http-request="map{ 'method': 'GET', 'href': $uri, 'headers': map{ 'Accept': 'application/xhtml+xml' } }">
                    <xsl:call-template name="onDocumentLoad">
                        <xsl:with-param name="uri" select="ac:document-uri($uri)"/>
                        <xsl:with-param name="fragment" select="encode-for-uri($uri)"/>
                    </xsl:call-template>
                </ixsl:schedule-action>
                <!-- remove the modal div -->
                <xsl:sequence select="ixsl:call($form/ancestor::div[tokenize(@class, ' ') = 'modal'], 'remove', [])[current-date() lt xs:date('2000-01-01')]"/>
            </xsl:when>
            <!-- special case for save query forms: simpy hide the modal form -->
            <xsl:when test="tokenize($form/@class, ' ') = ('form-save-query')">
                <!-- remove the modal div -->
                <xsl:sequence select="ixsl:call($form/ancestor::div[tokenize(@class, ' ') = 'modal'], 'remove', [])[current-date() lt xs:date('2000-01-01')]"/>
                <ixsl:set-style name="cursor" select="'default'" object="ixsl:page()//body"/>
            </xsl:when>
            <xsl:when test="?status = 200">
                <!-- trim the query string if it's present -->
                <xsl:variable name="uri" select="if (contains($action, '?')) then xs:anyURI(substring-before($action, '?')) else $action" as="xs:anyURI"/>
                <!-- reload resource -->
                <ixsl:schedule-action http-request="map{ 'method': 'GET', 'href': $uri, 'headers': map{ 'Accept': 'application/xhtml+xml' } }">
                    <xsl:call-template name="onDocumentLoad">
                        <xsl:with-param name="uri" select="ac:document-uri($uri)"/>
                        <xsl:with-param name="fragment" select="encode-for-uri($uri)"/>
                    </xsl:call-template>
                </ixsl:schedule-action>
            </xsl:when>
            <!-- POST created new resource successfully -->
            <xsl:when test="?status = 201 and ?headers?location">
                <xsl:variable name="created-uri" select="?headers?location" as="xs:anyURI"/>
                <xsl:choose>
                    <!-- signup succesfully completed -->
                    <xsl:when test="starts-with($action, resolve-uri('sign up', $ldt:base))">
                        <xsl:variable name="form-id" select="ixsl:get($form, 'id')" as="xs:string"/>
                        <xsl:for-each select="id($form-id, ixsl:page())/../..">
                            <xsl:result-document href="?." method="ixsl:replace-content">
                                <xsl:call-template name="bs2:SignedUp">
                                    <xsl:with-param name="created-uri" select="$created-uri"/>
                                </xsl:call-template>
                            </xsl:result-document>
                        </xsl:for-each>
                    </xsl:when>
                    <!-- access successfully requested -->
                    <xsl:when test="starts-with($action, resolve-uri('request access', $ldt:base))">
                        <xsl:variable name="form-id" select="ixsl:get($form, 'id')" as="xs:string"/>
                        <xsl:for-each select="id($form-id, ixsl:page())/../..">
                            <xsl:result-document href="?." method="ixsl:replace-content">
                                <xsl:call-template name="bs2:AccessRequested"/>
                            </xsl:result-document>
                        </xsl:for-each>
                    </xsl:when>
                    <!-- render the created resource as a typeahead input -->
                    <xsl:when test="$typeahead-span">
                        <ixsl:schedule-action http-request="map{ 'method': 'GET', 'href': $created-uri, 'headers': map{ 'Accept': 'application/rdf+xml' } }">
                            <xsl:call-template name="onTypeaheadResourceLoad">
                                <xsl:with-param name="resource-uri" select="$created-uri"/>
                                <xsl:with-param name="typeahead-span" select="$typeahead-span"/>
                                <xsl:with-param name="modal-form" select="$form"/>
                            </xsl:call-template>
                        </ixsl:schedule-action>
                    </xsl:when>
                    <!-- if the form submit did not originate from a typeahead (target), load the created resource -->
                    <xsl:otherwise>
                        <ixsl:schedule-action http-request="map{ 'method': 'GET', 'href': $created-uri, 'headers': map{ 'Accept': 'application/xhtml+xml' } }">
                            <xsl:call-template name="onDocumentLoad">
                                <xsl:with-param name="uri" select="ac:document-uri($created-uri)"/>
                                <xsl:with-param name="fragment" select="encode-for-uri($created-uri)"/>
                            </xsl:call-template>
                        </ixsl:schedule-action>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!-- POST or PUT constraint violation response is 400 Bad Request -->
            <xsl:when test="?status = 400 and ?media-type = 'application/xhtml+xml'">
                <xsl:for-each select="?body">
                    <xsl:variable name="form-id" select="ixsl:get($form, 'id')" as="xs:string"/>
                    <xsl:variable name="doc-id" select="concat('id', ixsl:call(ixsl:window(), 'generateUUID', []))" as="xs:string"/>
                    <xsl:variable name="form" as="element()">
                        <xsl:apply-templates select="//form[@class = 'form-horizontal']" mode="form">
                            <xsl:with-param name="target-id" select="$target-id" tunnel="yes"/>
                            <xsl:with-param name="doc-id" select="$doc-id" tunnel="yes"/>
                        </xsl:apply-templates>
                    </xsl:variable>
                    
                    <xsl:result-document href="#{$form-id}" method="ixsl:replace-content">
                        <xsl:copy-of select="$form/*"/>
                    </xsl:result-document>

                    <xsl:call-template name="add-form-listeners">
                        <xsl:with-param name="id" select="$form-id"/>
                    </xsl:call-template>
                    
                    <ixsl:set-style name="cursor" select="'default'" object="ixsl:page()//body"/>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <ixsl:set-style name="cursor" select="'default'" object="ixsl:page()//body"/>
                <xsl:value-of select="ixsl:call(ixsl:window(), 'alert', [ ?message ])"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="bs2:SignedUp">
        <xsl:param name="created-uri" as="xs:anyURI"/>
        <xsl:param name="class" select="'alert alert-success row-fluid offset2 span7'" as="xs:string?"/>

        <div>
            <xsl:if test="$class">
                <xsl:attribute name="class"><xsl:value-of select="$class"/></xsl:attribute>
            </xsl:if>
            
            <div class="span1">
                <img src="{resolve-uri('static/com/atomgraph/linkeddatahub/icons/baseline_done_white_48dp.png', $ac:contextUri)}" alt="Signup complete"/>
            </div>
            <div class="span11">
                <p>Congratulations! Your <a href="{$created-uri}">WebID profile</a> has been created. You can see its data below.</p>
                <p>
                    <strong>Authentication details have been sent to your email address.</strong>
                </p>
            </div>
        </div>
    </xsl:template>
    
    <xsl:template name="bs2:AccessRequested">
        <xsl:param name="class" select="'alert alert-success row-fluid offset2 span7'" as="xs:string?"/>

        <div>
            <xsl:if test="$class">
                <xsl:attribute name="class"><xsl:value-of select="$class"/></xsl:attribute>
            </xsl:if>
            
            <div class="span1">
                <img src="{resolve-uri('static/com/atomgraph/linkeddatahub/icons/baseline_done_white_48dp.png', $ac:contextUri)}" alt="Request created"/>
            </div>
            <div class="span11">
                <p>Your access request has been created.</p>
                <p>You will be notified when the administrator approves or rejects it.</p>
            </div>
        </div>
    </xsl:template>
    
    <!-- validate form before submitting it and show errors on control-groups where input values are missing -->
    <xsl:template match="form[@id = 'form-add-data'] | form[@id = 'form-clone-data']" mode="ixsl:onsubmit" priority="1">
        <xsl:variable name="control-groups" select="descendant::div[tokenize(@class, ' ') = 'control-group'][input[@name = 'pu'][@value = ('&nfo;fileName', '&dct;source', '&sd;name')]]" as="element()*"/>
        <xsl:choose>
            <!-- values missing, throw an error -->
            <xsl:when test="some $input in $control-groups/descendant::input[@name = ('ol', 'ou')] satisfies not(ixsl:get($input, 'value'))">
                <xsl:sequence select="ixsl:call(ixsl:event(), 'preventDefault', [])"/>
                <xsl:sequence select="$control-groups/ixsl:call(ixsl:get(., 'classList'), 'toggle', [ 'error', true() ])[current-date() lt xs:date('2000-01-01')]"/>
            </xsl:when>
            <!-- all required values present, apply the default form onsubmit -->
            <xsl:otherwise>
                <xsl:sequence select="$control-groups/ixsl:call(ixsl:get(., 'classList'), 'toggle', [ 'error', false() ])[current-date() lt xs:date('2000-01-01')]"/>
                <xsl:next-match/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- open drop-down by toggling its CSS class -->

    <xsl:template match="*[tokenize(@class, ' ') = 'btn-group'][*[tokenize(@class, ' ') = 'dropdown-toggle']]" mode="ixsl:onclick">
        <xsl:sequence select="ixsl:call(ixsl:get(., 'classList'), 'toggle', [ 'open' ])[current-date() lt xs:date('2000-01-01')]"/>
    </xsl:template>
    
    <xsl:template match="div[tokenize(@class, ' ') = 'hero-unit']/button[tokenize(@class, ' ') = 'close']" mode="ixsl:onclick" priority="1">
        <!-- remove the hero-unit -->
        <xsl:for-each select="..">
            <xsl:message>
                <xsl:value-of select="ixsl:call(., 'remove', [])"/>
            </xsl:message>
        </xsl:for-each>
        <!-- set a cookie to never show it again -->
        <ixsl:set-property name="cookie" select="concat('LinkedDataHub.first-time-message=true; path=/', substring-after($ldt:base, $ac:contextUri), '; expires=Fri, 31 Dec 9999 23:59:59 GMT')" object="ixsl:page()"/>
    </xsl:template>
    
    <!-- trigger typeahead in the search bar -->
    
    <xsl:template match="input[@id = 'uri']" mode="ixsl:onkeyup" priority="1">
        <xsl:param name="text" select="ixsl:get(., 'value')" as="xs:string?"/>
        <xsl:param name="menu" select="following-sibling::ul" as="element()"/>
        <xsl:param name="delay" select="400" as="xs:integer"/>
        <xsl:param name="container-uri" select="$search-container-uri" as="xs:anyURI"/>
        <xsl:param name="resource-types" as="xs:anyURI?"/>
        <!-- TO-DO: use <ixsl:schedule-action> instead -->
<!--        <xsl:param name="container-doc" select="document(ac:build-uri($container-uri, map{ 'accept': 'application/rdf+xml' }))" as="document-node()"/>-->
        <xsl:param name="select-uri" select="resolve-uri('queries/default/select-labelled/#this', $ldt:base)" as="xs:anyURI"/>
        <xsl:param name="select-doc" select="document(ac:build-uri(ac:document-uri($select-uri), map{ 'accept': 'application/rdf+xml' }))" as="document-node()"/>
        <xsl:param name="select-string" select="key('resources', $select-uri, $select-doc)/sp:text" as="xs:string"/>
        <xsl:param name="limit" select="100" as="xs:integer"/>
        <xsl:variable name="key-code" select="ixsl:get(ixsl:event(), 'code')" as="xs:string"/>
        <!-- TO-DO: refactor query building using XSLT -->
        <xsl:variable name="select-builder" select="ixsl:call(ixsl:get(ixsl:get(ixsl:window(), 'SPARQLBuilder'), 'SelectBuilder'), 'fromString', [ $select-string ])"/>
        <!-- pseudo JS code: SPARQLBuilder.SelectBuilder.fromString(select-builder).wherePattern(SPARQLBuilder.QueryBuilder.filter(SPARQLBuilder.QueryBuilder.regex(QueryBuilder.var("label"), QueryBuilder.term(QueryBuilder.str($text))))) -->
        <xsl:variable name="select-builder" select="ixsl:call($select-builder, 'wherePattern', [ ixsl:call(ixsl:get(ixsl:get(ixsl:window(), 'SPARQLBuilder'), 'QueryBuilder'), 'filter', [ ixsl:call(ixsl:get(ixsl:get(ixsl:window(), 'SPARQLBuilder'), 'QueryBuilder'), 'regex', [ ixsl:call(ixsl:get(ixsl:get(ixsl:window(), 'SPARQLBuilder'), 'QueryBuilder'), 'str', [ ixsl:call(ixsl:get(ixsl:get(ixsl:window(), 'SPARQLBuilder'), 'QueryBuilder'), 'var', [ 'label' ]) ]), ixsl:call(ixsl:get(ixsl:get(ixsl:window(), 'SPARQLBuilder'), 'QueryBuilder'), 'term', [ ac:escape-regex($text) ]), true() ] ) ] ) ])"/>
        <xsl:variable name="select-string" select="ixsl:call($select-builder, 'toString', [])" as="xs:string"/>
        <xsl:variable name="query-string" select="ac:build-describe($select-string, $limit, (), (), true())" as="xs:string"/>
        <xsl:variable name="service-uri" select="xs:anyURI(ixsl:get(id('search-service'), 'value'))" as="xs:anyURI?"/>
        <xsl:variable name="service" select="key('resources', $service-uri, ixsl:get(ixsl:window(), 'LinkedDataHub.services'))" as="element()?"/>
        <xsl:variable name="endpoint" select="if ($service) then xs:anyURI(($service/sd:endpoint/@rdf:resource, (if ($service/dydra:repository/@rdf:resource) then ($service/dydra:repository/@rdf:resource || 'sparql') else ()))[1]) else $ac:endpoint" as="xs:anyURI"/>
        
        <xsl:variable name="results-uri" select="ac:build-uri($endpoint, map{ 'query': string($query-string) })" as="xs:anyURI"/>
        <!-- TO-DO: use <ixsl:schedule-action> instead -->
        <xsl:variable name="results" select="document($results-uri)" as="document-node()"/>

        <xsl:choose>
            <xsl:when test="$key-code = 'Escape'">
                <xsl:call-template name="typeahead:hide">
                    <xsl:with-param name="menu" select="$menu"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$key-code = 'Enter'">
                <xsl:if test="$menu/li[tokenize(@class, ' ') = 'active']">
                    <!-- resource URI selected in the typeahead -->
                    <xsl:variable name="resource-uri" select="$menu/li[tokenize(@class, ' ') = 'active']/input[@name = 'ou']/ixsl:get(., 'value')" as="xs:anyURI"/>
                    <!-- indirect resource URI, dereferenced through a proxy -->
                    <xsl:variable name="request-uri" select="ac:build-uri($ldt:base, map { 'uri': string($resource-uri) })" as="xs:anyURI"/>
                    
                    <ixsl:set-style name="cursor" select="'progress'" object="ixsl:page()//body"/>

                    <ixsl:schedule-action http-request="map{ 'method': 'GET', 'href': $request-uri, 'headers': map{ 'Accept': 'application/xhtml+xml' } }">
                        <xsl:call-template name="onDocumentLoad">
                            <xsl:with-param name="uri" select="ac:document-uri($resource-uri)"/>
                            <xsl:with-param name="fragment" select="encode-for-uri($resource-uri)"/>
                        </xsl:call-template>
                    </ixsl:schedule-action>
                </xsl:if>
            </xsl:when>
            <xsl:when test="$key-code = 'ArrowUp'">
                <xsl:call-template name="typeahead:selection-up">
                    <xsl:with-param name="menu" select="$menu"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$key-code = 'ArrowDown'">
                <xsl:call-template name="typeahead:selection-down">
                    <xsl:with-param name="menu" select="$menu"/>
                </xsl:call-template>
            </xsl:when>
            <!-- ignore URIs in the input -->
            <xsl:when test="not(starts-with(ixsl:get(., 'value'), 'http://')) and not(starts-with(ixsl:get(., 'value'), 'https://'))">
                <ixsl:schedule-action wait="$delay">
                    <xsl:call-template name="typeahead:load-xml">
                        <xsl:with-param name="element" select="."/>
                        <xsl:with-param name="query" select="$text"/>
                        <xsl:with-param name="uri" select="$results-uri"/>
                    </xsl:call-template>
                </ixsl:schedule-action>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="typeahead:hide">
                    <xsl:with-param name="menu" select="$menu"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- navbar search typeahead item selected -->
    
    <xsl:template match="form[tokenize(@class, ' ') = 'navbar-form']//ul[tokenize(@class, ' ') = 'dropdown-menu'][tokenize(@class, ' ') = 'typeahead']/li" mode="ixsl:onmousedown" priority="1">
        <!-- redirect to the resource URI selected in the typeahead -->
        <xsl:variable name="resource-uri" select="input[@name = 'ou']/ixsl:get(., 'value')" as="xs:anyURI"/>
        <!-- indirect resource URI, dereferenced through a proxy -->
        <xsl:variable name="request-uri" select="ac:build-uri($ldt:base, map { 'uri': string($resource-uri) })" as="xs:anyURI"/>
        
        <ixsl:set-style name="cursor" select="'progress'" object="ixsl:page()//body"/>
        
        <ixsl:schedule-action http-request="map{ 'method': 'GET', 'href': $request-uri, 'headers': map{ 'Accept': 'application/xhtml+xml' } }">
            <xsl:call-template name="onDocumentLoad">
                <xsl:with-param name="uri" select="ac:document-uri($resource-uri)"/>
                <xsl:with-param name="fragment" select="encode-for-uri($resource-uri)"/>
            </xsl:call-template>
        </ixsl:schedule-action>
    </xsl:template>
    
    <!-- prompt for query title (also reused for its document) -->
    
    <xsl:template match="button[tokenize(@class, ' ') = 'btn-save-query']" mode="ixsl:onclick">
        <xsl:variable name="textarea-id" select="ancestor::form/descendant::textarea[@name = 'query']/ixsl:get(., 'id')" as="xs:string"/>
        <xsl:variable name="yasqe" select="ixsl:get(ixsl:get(ixsl:window(), 'LinkedDataHub.yasqe'), $textarea-id)"/>
        <xsl:variable name="query-string" select="ixsl:call($yasqe, 'getValue', [])" as="xs:string"/> <!-- get query string from YASQE -->
        <xsl:variable name="service-uri" select="xs:anyURI(ixsl:get(id('query-service'), 'value'))" as="xs:anyURI?"/>
        <xsl:variable name="forClass" select="resolve-uri('admin/model/ontologies/system/#Select', $ldt:base)" as="xs:anyURI"/>
        <!--- show a modal form if this button is in a <fieldset>, meaning on a resource-level and not form level. Otherwise (e.g. for the "Create" button) show normal form -->
        <xsl:variable name="modal-form" select="true()" as="xs:boolean"/>
        <xsl:variable name="href" select="ac:build-uri($ac:uri, let $params := map{ 'forClass': string($forClass) } return if ($modal-form) then map:merge(($params, map{ 'mode': '&ac;ModalMode' })) else $params)" as="xs:anyURI"/>
        <xsl:message>Form URI: <xsl:value-of select="$href"/></xsl:message>

        <ixsl:set-style name="cursor" select="'progress'" object="ixsl:page()//body"/>
        
        <ixsl:schedule-action http-request="map{ 'method': 'GET', 'href': $href, 'headers': map{ 'Accept': 'application/xhtml+xml' } }">
            <xsl:call-template name="onAddSaveQueryForm">
                <xsl:with-param name="query-string" select="$query-string"/>
            </xsl:call-template>
        </ixsl:schedule-action>
    </xsl:template>
    
    <!-- prompt for chart title (also reused for its document) -->
    
    <xsl:template match="button[tokenize(@class, ' ') = 'btn-save-chart']" mode="ixsl:onclick">
        <!-- prompt for title before form proceeds to submit -->
        <xsl:variable name="title" select="ixsl:call(ixsl:window(), 'prompt', [ 'Title' ])" as="xs:string"/>
        <xsl:choose>
            <xsl:when test="$title">
                <xsl:for-each select="id('chart-title')">
                    <ixsl:set-attribute name="value" select="$title"/>
                </xsl:for-each>
                <xsl:for-each select="id('chart-doc-title')">
                    <ixsl:set-attribute name="value" select="$title"/>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="ixsl:call(ixsl:event(), 'preventDefault', [])"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- open SPARQL editor -->
    
    <xsl:template match="a[tokenize(@class, ' ') = 'query-editor']" mode="ixsl:onclick">
        <xsl:variable name="container-id" select="'content-body'" as="xs:string"/>
        <xsl:variable name="textarea-id" select="'query-string'" as="xs:string"/>

        <xsl:sequence select="ixsl:call(ixsl:event(), 'preventDefault', [])"/>
        <xsl:result-document href="#{$container-id}" method="ixsl:replace-content">
            <xsl:call-template name="bs2:QueryEditor"/>
        </xsl:result-document>
        
        <!-- initialize YASQE on the textarea -->
        <xsl:variable name="js-statement" as="element()">
            <root statement="YASQE.fromTextArea(document.getElementById('{$textarea-id}'), {{ persistent: null }})"/>
        </xsl:variable>
        <ixsl:set-property name="{$textarea-id}" select="ixsl:eval(string($js-statement/@statement))" object="ixsl:get(ixsl:window(), 'LinkedDataHub.yasqe')"/>
    </xsl:template>

    <!-- open SPARQL editor and pass a query string -->
    
    <xsl:template match="form[tokenize(@class, ' ') = 'form-open-query']" mode="ixsl:onsubmit" priority="1">
        <xsl:variable name="container-id" select="'content-body'" as="xs:string"/>
        <xsl:variable name="textarea-id" select="'query-string'" as="xs:string"/>
        <xsl:variable name="form" select="." as="element()"/>
        <xsl:variable name="query-string" select="$form//input[@name = 'query']/ixsl:get(., 'value')" as="xs:string"/>
        
        <xsl:sequence select="ixsl:call(ixsl:event(), 'preventDefault', [])"/>
        <xsl:result-document href="#{$container-id}" method="ixsl:replace-content">
            <!-- set textarea's value to the query string from the hidden input -->
            <xsl:call-template name="bs2:QueryEditor">
                <xsl:with-param name="query" select="$query-string"/>
            </xsl:call-template>
        </xsl:result-document>
        
        <!-- initialize YASQE on the textarea -->
        <xsl:variable name="js-statement" as="element()">
            <root statement="YASQE.fromTextArea(document.getElementById('{$textarea-id}'), {{ persistent: null }})"/>
        </xsl:variable>
        <ixsl:set-property name="{$textarea-id}" select="ixsl:eval(string($js-statement/@statement))" object="ixsl:get(ixsl:window(), 'LinkedDataHub.yasqe')"/>
    </xsl:template>
    
    <!-- run SPARQL query in editor -->
    
    <!-- TO-DO: change to 'query-form' @class? -->
    <xsl:template match="form[@id = 'query-form']" mode="ixsl:onsubmit"> <!-- button[tokenize(@class, ' ') = 'btn-run-query'] -->
        <xsl:sequence select="ixsl:call(ixsl:event(), 'preventDefault', [])"/>
        <xsl:variable name="textarea-id" select="descendant::textarea[@name = 'query']/ixsl:get(., 'id')" as="xs:string"/>
        <xsl:variable name="yasqe" select="ixsl:get(ixsl:get(ixsl:window(), 'LinkedDataHub.yasqe'), $textarea-id)"/>
        <xsl:variable name="query-string" select="ixsl:call($yasqe, 'getValue', [])" as="xs:string"/> <!-- get query string from YASQE -->
        <xsl:variable name="service-uri" select="xs:anyURI(ixsl:get(id('query-service'), 'value'))" as="xs:anyURI?"/>
        <xsl:variable name="service" select="key('resources', $service-uri, ixsl:get(ixsl:window(), 'LinkedDataHub.services'))" as="element()?"/>
        <xsl:variable name="endpoint" select="if ($service) then xs:anyURI(($service/sd:endpoint/@rdf:resource, (if ($service/dydra:repository/@rdf:resource) then ($service/dydra:repository/@rdf:resource || 'sparql') else ()))[1]) else $ac:endpoint" as="xs:anyURI"/>

        <ixsl:set-style name="cursor" select="'progress'" object="ixsl:page()//body"/>

        <xsl:variable name="container-id" select="'sparql-results'" as="xs:string"/>
        <!-- is SPARQL results element does not already exist, create one -->
        <xsl:if test="not(id($container-id, ixsl:page()))">
            <xsl:result-document href="#content-body" method="ixsl:append-content">
                <div id="{$container-id}"/>
            </xsl:result-document>
        </xsl:if>
        
        <!-- TO-DO: unify dydra: and dydra-urn: ? -->
        <xsl:variable name="results-uri" select="ac:build-uri($endpoint, map{ 'query': $query-string })" as="xs:anyURI"/>
        <xsl:variable name="request" select="map{ 'method': 'GET', 'href': $results-uri, 'headers': map{ 'Accept': 'application/sparql-results+xml,application/rdf+xml;q=0.9' } }" as="map(xs:string, item())"/>
<!--        <xsl:variable name="uuid" select="ixsl:call(ixsl:window(), 'generateUUID', [])" as="xs:string"/>
        <xsl:variable name="query-uri" select="resolve-uri('queries/' || $uuid || '/#this', $ldt:base)" as="xs:anyURI"/>-->
        <xsl:variable name="content-uri" select="xs:anyURI(translate($results-uri, '.', '-'))" as="xs:anyURI"/> <!-- replace dots -->

<!--        <xsl:result-document href="?." method="ixsl:append-content">
            <input name="href" type="hidden" value="{$query-uri}"/>
        </xsl:result-document>-->

        <ixsl:schedule-action http-request="$request">
            <xsl:call-template name="onSPARQLResultsLoad">
                <xsl:with-param name="content-uri" select="$content-uri"/>
                <xsl:with-param name="container-id" select="$container-id"/>
            </xsl:call-template>
        </ixsl:schedule-action>
    </xsl:template>
    
    <!-- chart-type onchange -->
    
    <xsl:template match="select[tokenize(@class, ' ') = 'chart-type']" mode="ixsl:onchange">
        <xsl:param name="chart-type" select="xs:anyURI(ixsl:get(., 'value'))" as="xs:anyURI?"/>
        <xsl:param name="category" select="../..//select[tokenize(@class, ' ') = 'chart-category']/ixsl:get(., 'value')" as="xs:string?"/>
        <xsl:param name="series" as="xs:string*">
            <xsl:for-each select="../..//select[tokenize(@class, ' ') = 'chart-series']">
                <xsl:variable name="select" select="." as="element()"/>
                <xsl:for-each select="0 to xs:integer(ixsl:get(., 'selectedOptions.length')) - 1">
                    <xsl:sequence select="ixsl:get(ixsl:call(ixsl:get($select, 'selectedOptions'), 'item', [ . ]), 'value')"/>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:param>
        <!-- $content-uri value comes either from 'resource-content' input or from an input in the 'query-form' -->
        <xsl:param name="content-uri" select="xs:anyURI(translate((ancestor::div[tokenize(@class, ' ') = 'resource-content']/input[@name = 'href']/@value, id('query-form', ixsl:page())//input[@name = 'href']/@value)[1], '.', '-'))" as="xs:anyURI"/>
        <xsl:param name="chart-canvas-id" select="ancestor::form/following-sibling::div/@id" as="xs:string"/>

        <xsl:variable name="results" select="ixsl:get(ixsl:get(ixsl:get(ixsl:window(), 'LinkedDataHub'), $content-uri), 'results')" as="document-node()"/>
                
        <xsl:if test="$chart-type and ($category or $results/rdf:RDF) and exists($series)">
            <xsl:variable name="data-table" select="if ($results/rdf:RDF) then ac:rdf-data-table($results, $category, $series) else ac:sparql-results-data-table($results, $category, $series)"/>
            <ixsl:set-property name="data-table" select="$data-table" object="ixsl:get(ixsl:get(ixsl:window(), 'LinkedDataHub'), $content-uri)"/>

            <xsl:call-template name="render-chart">
                <xsl:with-param name="data-table" select="$data-table"/>
                <xsl:with-param name="canvas-id" select="$chart-canvas-id"/>
                <xsl:with-param name="chart-type" select="$chart-type"/>
                <xsl:with-param name="category" select="$category"/>
                <xsl:with-param name="series" select="$series"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- category onchange -->

    <xsl:template match="select[tokenize(@class, ' ') = 'chart-category']" mode="ixsl:onchange">
        <xsl:param name="chart-type" select="../..//select[tokenize(@class, ' ') = 'chart-type']/ixsl:get(., 'value')" as="xs:anyURI?"/>
        <xsl:param name="category" select="ixsl:get(., 'value')" as="xs:string?"/>
        <xsl:param name="series" as="xs:string*">
            <xsl:for-each select="../..//select[tokenize(@class, ' ') = 'chart-series']">
                <xsl:variable name="select" select="." as="element()"/>
                <xsl:for-each select="0 to xs:integer(ixsl:get(., 'selectedOptions.length')) - 1">
                    <xsl:sequence select="ixsl:get(ixsl:call(ixsl:get($select, 'selectedOptions'), 'item', [ . ]), 'value')"/>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:param>
        <!-- $content-uri value comes either from 'resource-content' input or from an input in the 'query-form' -->
        <xsl:param name="content-uri" select="xs:anyURI(translate((ancestor::div[tokenize(@class, ' ') = 'resource-content']/input[@name = 'href']/@value, id('query-form', ixsl:page())//input[@name = 'href']/@value)[1], '.', '-'))" as="xs:anyURI"/>
        <xsl:param name="chart-canvas-id" select="ancestor::form/following-sibling::div/@id" as="xs:string"/>
        <xsl:variable name="results" select="ixsl:get(ixsl:get(ixsl:get(ixsl:window(), 'LinkedDataHub'), $content-uri), 'results')" as="document-node()"/>

        <xsl:if test="$chart-type and ($category or $results/rdf:RDF) and exists($series)">
            <xsl:variable name="data-table" select="if ($results/rdf:RDF) then ac:rdf-data-table($results, $category, $series) else ac:sparql-results-data-table($results, $category, $series)"/>
            <ixsl:set-property name="data-table" select="$data-table" object="ixsl:get(ixsl:get(ixsl:window(), 'LinkedDataHub'), $content-uri)"/>

            <xsl:call-template name="render-chart">
                <xsl:with-param name="data-table" select="$data-table"/>
                <xsl:with-param name="canvas-id" select="$chart-canvas-id"/>
                <xsl:with-param name="chart-type" select="$chart-type"/>
                <xsl:with-param name="category" select="$category"/>
                <xsl:with-param name="series" select="$series"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <!-- series onchange -->

    <xsl:template match="select[tokenize(@class, ' ') = 'chart-series']" mode="ixsl:onchange">
        <xsl:param name="chart-type" select="../..//select[tokenize(@class, ' ') = 'chart-type']/ixsl:get(., 'value')" as="xs:anyURI?"/>
        <xsl:param name="category" select="../..//select[tokenize(@class, ' ') = 'chart-category']/ixsl:get(., 'value')" as="xs:string?"/>
        <xsl:param name="series" as="xs:string*">
            <xsl:variable name="select" select="." as="element()"/>
            <xsl:for-each select="0 to xs:integer(ixsl:get(., 'selectedOptions.length')) - 1">
                <xsl:sequence select="ixsl:get(ixsl:call(ixsl:get($select, 'selectedOptions'), 'item', [ . ]), 'value')"/>
            </xsl:for-each>
        </xsl:param>
        <!-- $content-uri value comes either from 'resource-content' input or from an input in the 'query-form' -->
        <xsl:param name="content-uri" select="xs:anyURI(translate((ancestor::div[tokenize(@class, ' ') = 'resource-content']/input[@name = 'href']/@value, id('query-form', ixsl:page())//input[@name = 'href']/@value)[1], '.', '-'))" as="xs:anyURI"/>
        <xsl:param name="chart-canvas-id" select="ancestor::form/following-sibling::div/@id" as="xs:string"/>
        <xsl:variable name="results" select="ixsl:get(ixsl:get(ixsl:get(ixsl:window(), 'LinkedDataHub'), $content-uri), 'results')" as="document-node()"/>

        <xsl:if test="$chart-type and ($category or $results/rdf:RDF) and exists($series)">
            <xsl:variable name="data-table" select="if ($results/rdf:RDF) then ac:rdf-data-table($results, $category, $series) else ac:sparql-results-data-table($results, $category, $series)"/>
            <ixsl:set-property name="data-table" select="$data-table" object="ixsl:get(ixsl:get(ixsl:window(), 'LinkedDataHub'), $content-uri)"/>

            <xsl:call-template name="render-chart">
                <xsl:with-param name="data-table" select="$data-table"/>
                <xsl:with-param name="canvas-id" select="$chart-canvas-id"/>
                <xsl:with-param name="chart-type" select="$chart-type"/>
                <xsl:with-param name="category" select="$category"/>
                <xsl:with-param name="series" select="$series"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <!-- types (Classes) are looked up on the NamespaceOntology rather on the SearchContainer -->
    <xsl:template match="input[tokenize(@class, ' ') = 'type-typeahead']" mode="ixsl:onkeyup" priority="1">
        <xsl:next-match>
            <xsl:with-param name="results-uri" select="resolve-uri('admin/model/ontologies/domain/', $ldt:base)"/>
        </xsl:next-match>
    </xsl:template>
    
    <!-- lookup by ?label and optional ?Type using search SELECT -->
    <xsl:template match="input[tokenize(@class, ' ') = 'typeahead']" mode="ixsl:onkeyup">
        <xsl:param name="menu" select="following-sibling::ul" as="element()"/>
        <xsl:param name="delay" select="400" as="xs:integer"/>
        <xsl:param name="endpoint" select="resolve-uri('sparql', $ldt:base)" as="xs:anyURI"/>
        <xsl:param name="results-uri" as="xs:anyURI?"/>
        <xsl:param name="container-uri" select="$search-container-uri" as="xs:anyURI?"/>
        <xsl:param name="resource-types" select="ancestor::div[@class = 'controls']/input[@class = 'forClass']/@value" as="xs:anyURI*"/>
        <!-- TO-DO: use <ixsl:schedule-action> instead of document() -->
<!--        <xsl:param name="container-doc" select="document(ac:build-uri($container-uri, map{ 'accept': 'application/rdf+xml' }))" as="document-node()?"/>-->
        <xsl:param name="select-uri" select="resolve-uri('queries/default/select-labelled/#this', $ldt:base)" as="xs:anyURI"/>
        <!-- TO-DO: use <ixsl:schedule-action> instead -->
        <xsl:param name="select-doc" select="document(ac:build-uri(ac:document-uri($select-uri), map{ 'accept': 'application/rdf+xml' }))" as="document-node()?"/>
        <xsl:param name="select-string" select="key('resources', $select-uri, $select-doc)/sp:text" as="xs:string?"/>
        <xsl:param name="limit" select="100" as="xs:integer?"/>
        <xsl:variable name="key-code" select="ixsl:get(ixsl:event(), 'code')" as="xs:string"/>
        <!-- convert resource type URIs to SPARQLBuilder URIs -->
        <xsl:variable name="value-uris" select="array { for $uri in $resource-types[not(. = '&rdfs;Resource')] return ixsl:call(ixsl:get(ixsl:get(ixsl:window(), 'SPARQLBuilder'), 'QueryBuilder'), 'uri', [ $uri ]) }"/>
        <xsl:variable name="select-builder" select="ixsl:call(ixsl:get(ixsl:get(ixsl:window(), 'SPARQLBuilder'), 'SelectBuilder'), 'fromString', [ $select-string ])"/>
        <!-- pseudo JS code: SPARQLBuilder.SelectBuilder.fromString(select-builder).wherePattern(SPARQLBuilder.QueryBuilder.filter(SPARQLBuilder.QueryBuilder.regex(QueryBuilder.var("label"), QueryBuilder.term($value)))) -->
        <xsl:variable name="select-builder" select="ixsl:call($select-builder, 'wherePattern', [ ixsl:call(ixsl:get(ixsl:get(ixsl:window(), 'SPARQLBuilder'), 'QueryBuilder'), 'filter', [ ixsl:call(ixsl:get(ixsl:get(ixsl:window(), 'SPARQLBuilder'), 'QueryBuilder'), 'regex', [ ixsl:call(ixsl:get(ixsl:get(ixsl:window(), 'SPARQLBuilder'), 'QueryBuilder'), 'str', [ ixsl:call(ixsl:get(ixsl:get(ixsl:window(), 'SPARQLBuilder'), 'QueryBuilder'), 'var', [ 'label' ]) ]), ixsl:call(ixsl:get(ixsl:get(ixsl:window(), 'SPARQLBuilder'), 'QueryBuilder'), 'term', [ ac:escape-regex(ixsl:get(., 'value')) ]), true() ]) ]) ])"/>
        <!-- pseudo JS code: SPARQLBuilder.SelectBuilder.fromString(select-builder).wherePattern(SPARQLBuilder.QueryBuilder.filter(SPARQLBuilder.QueryBuilder.in(QueryBuilder.var("Type"), [ $value ]))) -->
        <xsl:variable name="select-builder" select="if (empty($resource-types[not(. = '&rdfs;Resource')])) then $select-builder else ixsl:call($select-builder, 'wherePattern', [ ixsl:call(ixsl:get(ixsl:get(ixsl:window(), 'SPARQLBuilder'), 'QueryBuilder'), 'filter', [ ixsl:call(ixsl:get(ixsl:get(ixsl:window(), 'SPARQLBuilder'), 'QueryBuilder'), 'in', [ ixsl:call(ixsl:get(ixsl:get(ixsl:window(), 'SPARQLBuilder'), 'QueryBuilder'), 'var', [ 'Type' ]), $value-uris ]) ]) ])"/>
        <xsl:variable name="select-string" select="ixsl:call($select-builder, 'toString', [])" as="xs:string?"/>
        <xsl:variable name="query-string" select="ac:build-describe($select-string, $limit, (), (), true())" as="xs:string?"/>
        <xsl:variable name="results-uri" select="if ($results-uri) then $results-uri else ac:build-uri($endpoint, map{ 'query': string($query-string) })" as="xs:anyURI"/>
        <!-- TO-DO: use <ixsl:schedule-action> instead of document() -->
        <xsl:variable name="results" select="document($results-uri)" as="document-node()"/>
        
        <xsl:choose>
            <xsl:when test="$key-code = 'Escape'">
                <xsl:call-template name="typeahead:hide">
                    <xsl:with-param name="menu" select="$menu"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$key-code = 'Enter'">
                <xsl:for-each select="$menu/li[tokenize(@class, ' ') = 'active']">
                    <xsl:sequence select="ixsl:call(ixsl:event(), 'preventDefault', [])"/> <!-- prevent form submit -->
                
                    <xsl:variable name="resource-uri" select="input[@name = 'ou']/ixsl:get(., 'value')" as="xs:anyURI"/>
                    <xsl:variable name="typeahead-class" select="'btn add-typeahead'" as="xs:string"/>
                    <xsl:variable name="typeahead-doc" select="ixsl:get(ixsl:window(), 'LinkedDataHub.typeahead.rdfXml')" as="document-node()"/> <!-- set by typeahead:xml-loaded -->
                    <xsl:variable name="resource" select="key('resources', $resource-uri, $typeahead-doc)"/>

                    <xsl:for-each select="../..">
                        <xsl:result-document href="?." method="ixsl:replace-content">
                            <xsl:apply-templates select="$resource" mode="apl:Typeahead">
                                <xsl:with-param name="class" select="$typeahead-class"/>
                            </xsl:apply-templates>
                        </xsl:result-document>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="$key-code = 'ArrowUp'">
                <xsl:call-template name="typeahead:selection-up">
                    <xsl:with-param name="menu" select="$menu"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$key-code = 'ArrowDown'">
                <xsl:call-template name="typeahead:selection-down">
                    <xsl:with-param name="menu" select="$menu"/>
                </xsl:call-template>
            </xsl:when>
            <!-- ignore URIs in the input -->
            <xsl:when test="not(starts-with(ixsl:get(., 'value'), 'http://')) and not(starts-with(ixsl:get(., 'value'), 'https://'))">
                <ixsl:schedule-action wait="$delay">
                    <xsl:call-template name="typeahead:load-xml">
                        <xsl:with-param name="element" select="."/>
                        <xsl:with-param name="query" select="ixsl:get(., 'value')"/>
                        <xsl:with-param name="uri" select="$results-uri"/>
                        <xsl:with-param name="resource-types" select="$resource-types"/>
                    </xsl:call-template>
                </ixsl:schedule-action>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="typeahead:hide">
                    <xsl:with-param name="menu" select="$menu"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="input[tokenize(@class, ' ') = 'typeahead']" mode="ixsl:onblur">
        <xsl:param name="menu" select="following-sibling::ul" as="element()"/>
        
        <xsl:call-template name="typeahead:hide">
            <xsl:with-param name="menu" select="$menu"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="ul[tokenize(@class, ' ') = 'dropdown-menu'][tokenize(@class, ' ') = 'type-typeahead']/li" mode="ixsl:onmousedown" priority="1">
        <xsl:next-match>
            <xsl:with-param name="typeahead-class" select="'btn add-typeahead add-typetypeahead'"/>
        </xsl:next-match>
    </xsl:template>
    
    <!-- select typeahead item -->
    
    <xsl:template match="ul[tokenize(@class, ' ') = 'dropdown-menu'][tokenize(@class, ' ') = 'typeahead']/li" mode="ixsl:onmousedown">
        <xsl:param name="resource-uri" select="input[@name = 'ou']/ixsl:get(., 'value')"/>
        <xsl:param name="typeahead-class" select="'btn add-typeahead'" as="xs:string"/>
        <xsl:variable name="typeahead-doc" select="ixsl:get(ixsl:window(), 'LinkedDataHub.typeahead.rdfXml')"/>
        <xsl:variable name="resource" select="key('resources', $resource-uri, $typeahead-doc)"/>

        <xsl:for-each select="../..">
            <xsl:result-document href="?." method="ixsl:replace-content">
                <xsl:apply-templates select="$resource" mode="apl:Typeahead">
                    <xsl:with-param name="class" select="$typeahead-class"/>
                </xsl:apply-templates>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>

    <!-- remove <fieldset> (button is within <legend>) -->
    <xsl:template match="fieldset/legend/div/button[tokenize(@class, ' ') = 'btn-remove-resource']" mode="ixsl:onclick" priority="1">
        <xsl:message>
            <xsl:value-of select="ixsl:call(../../.., 'remove', [])"/>
        </xsl:message>
    </xsl:template>

    <!-- remove <fieldset> (button is within <fieldset>) -->
    <xsl:template match="fieldset/div/button[tokenize(@class, ' ') = 'btn-remove-resource']" mode="ixsl:onclick" priority="1">
        <xsl:message>
            <xsl:value-of select="ixsl:call(../.., 'remove', [])"/>
        </xsl:message>
    </xsl:template>

    <!-- remove <div class="control-group"> -->
    <xsl:template match="button[tokenize(@class, ' ') = 'btn-remove-property']" mode="ixsl:onclick" priority="1">
        <xsl:message>
            <xsl:value-of select="ixsl:call(../../.., 'remove', [])"/>
        </xsl:message>
    </xsl:template>

    <xsl:template match="button[tokenize(@class, ' ') = 'add-type']" mode="ixsl:onclick" priority="1">
        <xsl:param name="lookup-class" select="'type-typeahead typeahead'" as="xs:string"/>
        <xsl:param name="lookup-list-class" select="'type-typeahead typeahead dropdown-menu'" as="xs:string"/>
        <xsl:variable name="uuid" select="ixsl:call(ixsl:window(), 'generateUUID', [])" as="xs:string"/>
        
        <xsl:for-each select="..">
            <xsl:result-document href="?." method="ixsl:replace-content">
                <xsl:call-template name="bs2:Lookup">
                    <xsl:with-param name="class" select="$lookup-class"/>
                    <xsl:with-param name="id" select="concat('input-', $uuid)"/>
                    <xsl:with-param name="list-class" select="$lookup-list-class"/>
                </xsl:call-template>
            </xsl:result-document>
        </xsl:for-each>
        <xsl:for-each select="../..">
            <xsl:result-document href="?." method="ixsl:append-content">
                <xsl:copy-of select=".."/>
            </xsl:result-document>
        </xsl:for-each>

        <xsl:call-template name="add-typeahead">
            <xsl:with-param name="id" select="concat('input-', $uuid)"/>
        </xsl:call-template>
    </xsl:template>

    <!-- special case for rdf:type lookups -->
    <xsl:template match="button[tokenize(@class, ' ') = 'add-typetypeahead']" mode="ixsl:onclick" priority="1">
        <xsl:next-match>
            <xsl:with-param name="lookup-class" select="'type-typeahead typeahead'"/>
            <xsl:with-param name="lookup-list-class" select="'type-typeahead typeahead dropdown-menu'" as="xs:string"/>
        </xsl:next-match>
    </xsl:template>
    
    <xsl:template match="button[tokenize(@class, ' ') = 'add-typeahead']" mode="ixsl:onclick">
        <xsl:param name="lookup-class" select="'resource-typeahead typeahead'" as="xs:string"/>
        <xsl:param name="lookup-list-class" select="'resource-typeahead typeahead dropdown-menu'" as="xs:string"/>
        <xsl:variable name="uuid" select="ixsl:call(ixsl:window(), 'generateUUID', [])" as="xs:string"/>
        
        <xsl:for-each select="..">
            <xsl:result-document href="?." method="ixsl:replace-content">
                <xsl:call-template name="bs2:Lookup">
                    <xsl:with-param name="class" select="$lookup-class"/>
                    <xsl:with-param name="id" select="concat('input-', $uuid)"/>
                    <xsl:with-param name="list-class" select="$lookup-list-class"/>
                </xsl:call-template>
            </xsl:result-document>
        </xsl:for-each>

        <xsl:call-template name="add-typeahead">
            <xsl:with-param name="id" select="concat('input-', $uuid)"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="add-typeahead">
        <xsl:param name="id" as="xs:string"/>
        
        <xsl:for-each select="id($id, ixsl:page())">
            <xsl:message>
                <xsl:value-of select="ixsl:call(., 'addEventListener', [ 'blur', ixsl:get(ixsl:window(), 'onTypeaheadInputBlur') ])"/>
                <xsl:value-of select="ixsl:call(., 'focus', [])"/>
            </xsl:message>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="button[tokenize(@class, ' ') = 'add-value']" mode="ixsl:onclick">
        <xsl:variable name="control-group" select="../.." as="element()"/> <!-- ../../copy-of() -->
        <xsl:variable name="property" select="../preceding-sibling::*/select/option[ixsl:get(., 'selected') = true()]/ixsl:get(., 'value')" as="xs:anyURI"/>
        <xsl:variable name="forClass" select="preceding-sibling::input/@value" as="xs:anyURI*"/>
        <xsl:variable name="href" select="ac:build-uri($ac:uri, map{ 'forClass': string($forClass) })" as="xs:anyURI"/>
        <xsl:message>Form URI: <xsl:value-of select="$href"/></xsl:message>
        
        <ixsl:schedule-action http-request="map{ 'method': 'GET', 'href': $href, 'headers': map{ 'Accept': 'application/xhtml+xml' } }">
            <xsl:call-template name="onaddValueCallback">
                <xsl:with-param name="forClass" select="$forClass"/>
                <xsl:with-param name="control-group" select="$control-group"/>
                <xsl:with-param name="property" select="$property"/>
            </xsl:call-template>
        </ixsl:schedule-action>
    </xsl:template>

    <xsl:template match="button[tokenize(@class, ' ') = 'add-constructor']" mode="ixsl:onclick">
        <xsl:variable name="forClass" select="input[@class = 'forClass']/@value" as="xs:anyURI"/>
        <!--- show a modal form if this button is in a <fieldset>, meaning on a resource-level and not form level. Otherwise (e.g. for the "Create" button) show normal form -->
        <xsl:variable name="modal-form" select="exists(ancestor::fieldset)" as="xs:boolean"/>
        <xsl:variable name="href" select="ac:build-uri($ac:uri, let $params := map{ 'forClass': string($forClass) } return if ($modal-form) then map:merge(($params, map{ 'mode': '&ac;ModalMode' })) else $params)" as="xs:anyURI"/>
        <xsl:message>Form URI: <xsl:value-of select="$href"/></xsl:message>

        <ixsl:set-style name="cursor" select="'progress'" object="ixsl:page()//body"/>
        
        <ixsl:schedule-action http-request="map{ 'method': 'GET', 'href': $href, 'headers': map{ 'Accept': 'application/xhtml+xml' } }">
            <xsl:call-template name="onAddForm"/>
        </ixsl:schedule-action>
    </xsl:template>

    <xsl:template match="button[tokenize(@class, ' ') = 'btn-add-data']" mode="ixsl:onclick">
        <xsl:call-template name="apl:ShowAddDataForm"/>
    </xsl:template>

    <xsl:template match="button[tokenize(@class, ' ') = 'btn-edit']" mode="ixsl:onclick">
        <xsl:variable name="uri" select="xs:anyURI(ixsl:get(ixsl:window(), 'LinkedDataHub.href'))" as="xs:anyURI"/>
        <xsl:variable name="request-uri" select="if (not(starts-with($uri, $ldt:base))) then ac:build-uri($ldt:base, map{ 'uri': string($uri), 'mode': '&ac;EditMode' }) else ac:build-uri($uri, map{ 'mode': '&ac;EditMode' })" as="xs:anyURI"/>
        <xsl:message>GRAPH URI: <xsl:value-of select="$uri"/></xsl:message>

        <!-- toggle .active class -->
        <xsl:sequence select="ixsl:call(ixsl:get(., 'classList'), 'toggle', [ 'active', true() ])[current-date() lt xs:date('2000-01-01')]"/>
        <ixsl:set-style name="cursor" select="'progress'" object="ixsl:page()//body"/>
        
        <ixsl:schedule-action http-request="map{ 'method': 'GET', 'href': $request-uri, 'headers': map{ 'Accept': 'application/xhtml+xml' } }">
            <xsl:call-template name="onAddForm"/>
        </ixsl:schedule-action>
    </xsl:template>
    
    <xsl:template match="div[tokenize(@class, ' ') = 'modal']//button[tokenize(@class, ' ') = ('close', 'btn-close')]" mode="ixsl:onclick">
        <xsl:for-each select="ancestor::div[tokenize(@class, ' ') = 'modal']">
            <xsl:message>
                <xsl:value-of select="ixsl:call(., 'remove', [])"/>
            </xsl:message>
        </xsl:for-each>
    </xsl:template>
    
    <!-- content tabs (markup from Bootstrap) -->
    <xsl:template match="div[tokenize(@class, ' ') = 'tabbable']/ul[tokenize(@class, ' ') = 'nav-tabs']/li/a" mode="ixsl:onclick">
        <!-- deactivate other tabs -->
        <xsl:for-each select="../../li">
            <ixsl:set-attribute name="class" select="string-join(tokenize(@class, ' ')[not(. = 'active')], ' ')"/>
        </xsl:for-each>
        <!-- activate this tab -->
        <xsl:for-each select="..">
            <ixsl:set-attribute name="class" select="'active'"/>
        </xsl:for-each>
        <!-- deactivate other tab panes -->
        <xsl:for-each select="../../following-sibling::*[tokenize(@class, ' ') = 'tab-content']/*[tokenize(@class, ' ') = 'tab-pane']">
            <ixsl:set-attribute name="class" select="string-join(tokenize(@class, ' ')[not(. = 'active')], ' ')"/>
        </xsl:for-each>
        <!-- activate this tab -->
        <xsl:for-each select="../../following-sibling::*[tokenize(@class, ' ') = 'tab-content']/*[tokenize(@class, ' ') = 'tab-pane'][count(preceding-sibling::*[tokenize(@class, ' ') = 'tab-pane']) = count(current()/../preceding-sibling::li)]">
            <ixsl:set-attribute name="class" select="concat(@class, ' ', 'active')"/>
        </xsl:for-each>
    </xsl:template>
    
    <!-- simplified version of Bootstrap's tooltip() -->
    
    <xsl:template match="fieldset//input" mode="ixsl:onmouseover">
        <xsl:choose>
            <!-- show existing tooltip -->
            <xsl:when test="../div[tokenize(@class, ' ') = 'tooltip']">
                <ixsl:set-style name="display" select="'block'" object="../div[tokenize(@class, ' ') = 'tooltip']"/>
            </xsl:when>
            <!-- append new tooltip -->
            <xsl:otherwise>
                <xsl:variable name="description-span" select="ancestor::*[tokenize(@class, ' ') = 'control-group']//*[tokenize(@class, ' ') = 'description']" as="element()?"/>
                <xsl:if test="$description-span">
                    <xsl:variable name="input-offset-width" select="ixsl:get(., 'offsetWidth')" as="xs:integer"/>
                    <xsl:variable name="input-offset-height" select="ixsl:get(., 'offsetHeight')" as="xs:integer"/>
                    <xsl:for-each select="..">
                        <xsl:result-document href="?." method="ixsl:append-content">
                            <div class="tooltip fade top in">
                                <div class="tooltip-arrow"></div>
                                <div class="tooltip-inner">
                                    <xsl:sequence select="$description-span/text()"/>
                                </div>
                            </div>
                        </xsl:result-document>
                    </xsl:for-each>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
        <!-- adjust the position of the tooltip relative to the input -->
        <xsl:variable name="input-top" select="ixsl:get(., 'offsetTop')" as="xs:double"/>
        <xsl:variable name="input-left" select="ixsl:get(., 'offsetLeft')" as="xs:double"/>
        <xsl:variable name="input-width" select="ixsl:get(., 'offsetWidth')" as="xs:double"/>
        <xsl:for-each select="../div[tokenize(@class, ' ') = 'tooltip']">
            <xsl:variable name="tooltip-height" select="ixsl:get(., 'offsetHeight')" as="xs:double"/>
            <xsl:variable name="tooltip-width" select="ixsl:get(., 'offsetWidth')" as="xs:double"/>
            
            <ixsl:set-style name="top" select="($input-top - $tooltip-height) || 'px'"/>
            <ixsl:set-style name="left" select="($input-left + ($input-width - $tooltip-width) div 2) || 'px'"/>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="fieldset//input" mode="ixsl:onmouseout">
        <xsl:for-each select="../div[tokenize(@class, ' ') = 'tooltip']">
            <ixsl:set-style name="display" select="'none'"/>
        </xsl:for-each>
    </xsl:template>
    
    <!-- copy resource's URI into clipboard -->
    
    <xsl:template match="button[tokenize(@class, ' ') = 'btn-copy-uri']" mode="ixsl:onclick">
        <!-- get resource URI from its heading title attribute -->
        <xsl:variable name="uri" select="../../h2/a/@title" as="xs:anyURI"/>
        <xsl:sequence select="ixsl:call(ixsl:get(ixsl:window(), 'navigator.clipboard'), 'writeText', [ $uri ])"/>
    </xsl:template>

    <!-- open a form to save RDF document -->
    
    <xsl:template match="button[tokenize(@class, ' ') = 'btn-save-as']" mode="ixsl:onclick">
        <!-- do nothing is the button is disabled (e.g. SELECT results cannot be saved) -->
        <xsl:if test="not(tokenize(@class, ' ') = 'disabled')">
            <xsl:variable name="uri" select="xs:anyURI(ixsl:get(ixsl:window(), 'LinkedDataHub.href'))" as="xs:anyURI"/>
            <xsl:variable name="local-uri" select="xs:anyURI(ixsl:get(ixsl:window(), 'LinkedDataHub.local-href'))" as="xs:anyURI"/>

            <xsl:call-template name="apl:ShowAddDataForm">
                <xsl:with-param name="source" select="$uri"/>
                <xsl:with-param name="graph" select="resolve-uri(encode-for-uri($uri) || '/', $local-uri)"/>
                <xsl:with-param name="container" select="$local-uri"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- FORM IDENTITY TRANSFORM -->
    
    <xsl:template match="@for | @id" mode="form" priority="1">
        <xsl:param name="doc-id" as="xs:string" tunnel="yes"/>
        
        <xsl:attribute name="{name()}" select="concat($doc-id, .)"/>
    </xsl:template>
    
    <xsl:template match="input[@class = 'target-id']" mode="form" priority="1">
        <xsl:param name="target-id" as="xs:string?" tunnel="yes"/>
        
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="#current"/>
            <xsl:if test="$target-id">
                <xsl:attribute name="value" select="$target-id"/>
            </xsl:if>
        </xsl:copy>
    </xsl:template>

    <!-- regenerates slug literal UUID because form (X)HTML can be cached -->
    <xsl:template match="input[@name = 'ol'][ancestor::div[@class = 'controls']/preceding-sibling::input[@name = 'pu']/@value = '&dh;slug']" mode="form" priority="1">
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="#current"/>
            <xsl:attribute name="value" select="ixsl:call(ixsl:window(), 'generateUUID', [])"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@* | node()" mode="form">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="#current"/>
        </xsl:copy>
    </xsl:template>

    <!-- CALLBACKS -->
    
    <xsl:template name="onTypeaheadResourceLoad">
        <xsl:context-item as="map(*)" use="required"/>
        <xsl:param name="resource-uri" as="xs:anyURI"/>
        <xsl:param name="typeahead-span" as="element()"/>
        <xsl:param name="modal-form" as="element()?"/>

        <xsl:choose>
            <xsl:when test="?status = 200 and ?media-type = 'application/rdf+xml'">
                <xsl:for-each select="?body">
                    <xsl:variable name="resource" select="key('resources', $resource-uri)" as="element()"/>

                    <!-- remove modal constructor form -->
                    <xsl:if test="$modal-form">
                        <xsl:message>
                            <xsl:sequence select="ixsl:call($modal-form/.., 'remove', [])"/>
                        </xsl:message>
                    </xsl:if>

                    <xsl:for-each select="$typeahead-span">
                        <xsl:result-document href="?." method="ixsl:replace-content">
                            <xsl:apply-templates select="$resource" mode="apl:Typeahead"/>
                        </xsl:result-document>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="ixsl:call(ixsl:window(), 'alert', [ ?message ])"/>
            </xsl:otherwise>
        </xsl:choose>
        
        <ixsl:set-style name="cursor" select="'default'" object="ixsl:page()//body"/>
    </xsl:template>
    
    <xsl:template name="ixsl:ontypeTypeaheadCallback">
        <xsl:next-match>
            <xsl:with-param name="container-uri" select="resolve-uri('admin/model/ontologies/domain/', $ldt:base)"/>
        </xsl:next-match>
    </xsl:template>
    
    <!-- after "Create" or "Edit" buttons are clicked" -->
    <xsl:template name="onAddForm">
        <xsl:context-item as="map(*)" use="required"/>
        <xsl:param name="container-id" select="'content-body'" as="xs:string"/>
        <xsl:param name="add-class" as="xs:string?"/>

        <xsl:choose>
            <xsl:when test="?status = 200 and ?media-type = 'application/xhtml+xml'">
                <xsl:for-each select="?body">
                    <xsl:variable name="event" select="ixsl:event()"/>
                    <xsl:variable name="target" select="ixsl:get($event, 'target')"/>
                    <xsl:variable name="modal" select="exists(//div[tokenize(@class, ' ') = 'modal-constructor'])" as="xs:boolean"/>
                    <xsl:variable name="target-id" select="$target/@id" as="xs:string?"/>
                    <xsl:variable name="doc-id" select="concat('id', ixsl:call(ixsl:window(), 'generateUUID', []))" as="xs:string"/>
                    
                    <xsl:choose>
                        <xsl:when test="$modal">
                            <xsl:variable name="modal-div" as="element()">
                                <xsl:apply-templates select="//div[tokenize(@class, ' ') = 'modal-constructor']" mode="form">
                                    <xsl:with-param name="target-id" select="$target-id" tunnel="yes"/>
                                    <xsl:with-param name="doc-id" select="$doc-id" tunnel="yes"/>
                                </xsl:apply-templates>
                            </xsl:variable>
                            <xsl:variable name="form-id" select="$modal-div//form/@id" as="xs:string"/>
                            
                            <xsl:if test="$add-class">
                                <xsl:sequence select="$modal-div//form/ixsl:call(ixsl:get(., 'classList'), 'toggle', [ $add-class, true() ])[current-date() lt xs:date('2000-01-01')]"/>
                            </xsl:if>

                            <xsl:for-each select="ixsl:page()//body">
                                <xsl:result-document href="?." method="ixsl:append-content">
                                    <!-- append modal div to body -->
                                    <xsl:copy-of select="$modal-div"/>
                                </xsl:result-document>
                            </xsl:for-each>
                            
                            <!-- add event listeners to the descendants of the form -->
                            <xsl:call-template name="add-form-listeners">
                                <xsl:with-param name="id" select="$form-id"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:variable name="form" as="element()">
                                <xsl:apply-templates select="//form" mode="form">
                                    <xsl:with-param name="target-id" select="$target-id" tunnel="yes"/>
                                    <xsl:with-param name="doc-id" select="$doc-id" tunnel="yes"/>
                                </xsl:apply-templates>
                            </xsl:variable>
                            <xsl:variable name="form-id" select="$form/@id" as="xs:string"/>
                            
                            <xsl:if test="$add-class">
                                <xsl:sequence select="$form/ixsl:call(ixsl:get(., 'classList'), 'toggle', [ $add-class, true() ])[current-date() lt xs:date('2000-01-01')]"/>
                            </xsl:if>
                            
                            <xsl:choose>
                                <!-- if "Create" button is within the <form>, append elements to <form> -->
                                <xsl:when test="$target/ancestor::form[tokenize(@class, ' ') = 'form-horizontal']">
                                    <xsl:for-each select="$target/ancestor::form[tokenize(@class, ' ') = 'form-horizontal']">
                                        <!-- remove the old form-actions <div> because we'll be appending a new one below -->
                                        <xsl:for-each select="div[tokenize(@class, ' ') = 'form-actions']">
                                            <xsl:message>
                                                <xsl:value-of select="ixsl:call(., 'remove', [])"/>
                                            </xsl:message>
                                        </xsl:for-each>
                                        <!-- remove this "Create" button -->
                                        <xsl:for-each select="$target/ancestor::div[tokenize(@class, ' ') = 'btn-group'][button[tokenize(@class, ' ') = 'create-action']]">
                                            <xsl:message>
                                                <xsl:value-of select="ixsl:call(., 'remove', [])"/>
                                            </xsl:message>
                                        </xsl:for-each>

                                        <xsl:result-document href="?." method="ixsl:append-content">
                                            <xsl:copy-of select="$form/*"/>
                                        </xsl:result-document>
                                    </xsl:for-each>
                                </xsl:when>
                                <!-- there's no <form> so we're not in EditMode - replace the whole content -->
                                <xsl:otherwise>
                                    <xsl:result-document href="#{$container-id}" method="ixsl:replace-content">
                                        <div class="row-fluid">
                                            <div class="left-nav span2"></div>

                                            <div class="span7">
                                                <xsl:copy-of select="$form"/>
                                            </div>
                                        </div>
                                    </xsl:result-document>
                                </xsl:otherwise>
                            </xsl:choose>
                            
                            <!-- add event listeners to the descendants of the form -->
                            <xsl:call-template name="add-form-listeners">
                                <xsl:with-param name="id" select="$form-id"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>

                    <xsl:for-each select="ixsl:page()//body">
                        <ixsl:set-style name="cursor" select="'default'"/>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="ixsl:call(ixsl:window(), 'alert', [ ?message ])"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="onAddSaveQueryForm">
        <xsl:param name="query-string" as="xs:string"/>
        
        <xsl:call-template name="onAddForm">
            <xsl:with-param name="add-class" select="'form-save-query'"/>
        </xsl:call-template>
        
        <xsl:variable name="form" select="ixsl:page()//div[tokenize(@class, ' ') = 'modal-constructor']//form" as="element()"/>
        <!--<xsl:sequence select="ixsl:call(ixsl:window(), 'alert', [ 'Form ID: ' || $form-id ])"/>-->
        <xsl:variable name="control-group" select="$form/descendant::div[tokenize(@class, ' ') = 'control-group'][input[@name = 'pu'][@value = '&sp;text']]" as="element()*"/>
        <ixsl:set-property name="value" select="$query-string" object="$control-group/descendant::textarea[@name = 'ol']"/>
    </xsl:template>
    
    <xsl:template name="onaddValueCallback">
        <xsl:context-item as="map(*)" use="required"/>
        <xsl:param name="forClass" as="xs:anyURI"/>
        <xsl:param name="control-group" as="element()"/>
        <xsl:param name="property" as="xs:anyURI"/>
        
        <xsl:choose>
            <xsl:when test="?status = 200 and ?media-type = 'application/xhtml+xml'">
                <xsl:for-each select="?body">
                    <xsl:variable name="doc-id" select="concat('id', ixsl:call(ixsl:window(), 'generateUUID', []))" as="xs:string"/>
                    <xsl:variable name="form" as="element()">
                        <xsl:apply-templates select="//form[@class = 'form-horizontal']" mode="form">
<!--                            <xsl:with-param name="target-id" select="$target-id" tunnel="yes"/>-->
                            <xsl:with-param name="doc-id" select="$doc-id" tunnel="yes"/>
                        </xsl:apply-templates>
                    </xsl:variable>
                    <xsl:variable name="new-control-group" select="$form//div[tokenize(@class, ' ') = 'control-group'][input[@name = 'pu']/@value = $property]" as="element()"/>
                    
                    <xsl:for-each select="$control-group">
                        <!-- move property creation control group down, by appending it to the parent fieldset -->
                        <xsl:for-each select="$control-group/..">
                            <xsl:result-document href="?." method="ixsl:append-content">
                                <xsl:copy-of select="$control-group"/>
                            </xsl:result-document>
                        </xsl:for-each>

                        <xsl:result-document href="?." method="ixsl:replace-content">
                            <xsl:copy-of select="$new-control-group/*"/>
                        </xsl:result-document>
                        
                        <!-- apply WYMEditor on textarea if object is XMLLiteral -->
<!--                        <xsl:call-template name="add-value-listeners">
                            <xsl:with-param name="id" select="$new-control-group//input[@name = ('ob', 'ou', 'ol')]/@id"/>
                        </xsl:call-template>-->
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="ixsl:call(ixsl:window(), 'alert', [ ?message ])"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="add-value-listeners">
        <xsl:param name="id" as="xs:string"/>
        
        <xsl:for-each select="id($id, ixsl:page())">
            <xsl:apply-templates select="." mode="apl:PostConstructMode"/>
            
            <xsl:value-of select="ixsl:call(., 'focus', [])"/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="add-form-listeners">
        <xsl:param name="id" as="xs:string"/>
        <xsl:message>FORM ID: <xsl:value-of select="$id"/></xsl:message>

        <xsl:apply-templates select="id($id, ixsl:page())" mode="apl:PostConstructMode"/>
    </xsl:template>

    <xsl:template match="*" mode="apl:PostConstructMode">
        <xsl:apply-templates mode="#current"/>
    </xsl:template>
    
    <!-- LISTENER IDENTITY TRANSFORM - binding events to inputs -->
    
    <xsl:template match="text()" mode="apl:PostConstructMode"/>

    <!-- subject type change -->
    <xsl:template match="select[tokenize(@class, ' ') = 'subject-type']" mode="apl:PostConstructMode" priority="1">
        <xsl:message>
            <xsl:value-of select="ixsl:call(., 'addEventListener', [ 'change', ixsl:get(ixsl:window(), 'onSubjectTypeChange') ])"/>
        </xsl:message>
    </xsl:template>
    
    <xsl:template match="textarea[tokenize(@class, ' ') = 'wymeditor']" mode="apl:PostConstructMode" priority="1">
        <!-- without wrapping into comment, we get: SEVERE: In delayed event: DOM error appending text node with value: '[object Object]' to node with name: #document -->
        <xsl:message>
            <!-- call .wymeditor() on textarea to show WYMEditor -->
            <xsl:sequence select="ixsl:call(ixsl:call(ixsl:window(), 'jQuery', [ . ]), 'wymeditor', [])"/>
        </xsl:message>
    </xsl:template>

    <!-- TO-DO: phase out as regular ixsl: event templates -->
    <xsl:template match="fieldset//input" mode="apl:PostConstructMode" priority="1">
        <!-- subject value change -->
        <xsl:if test="tokenize(@class, ' ') = 'subject'">
            <xsl:message>
                <xsl:value-of select="ixsl:call(., 'addEventListener', [ 'change', ixsl:get(ixsl:window(), 'onSubjectValueChange') ])"/>
            </xsl:message>
        </xsl:if>
        <!-- typeahead blur -->
        <xsl:if test="tokenize(@class, ' ') = 'resource-typeahead'">
            <xsl:message>
                <xsl:value-of select="ixsl:call(., 'addEventListener', [ 'blur', ixsl:get(ixsl:window(), 'onTypeaheadInputBlur') ])"/>
            </xsl:message>
        </xsl:if>
        <!-- prepended/appended input -->
        <xsl:if test="@type = 'text' and ../tokenize(@class, ' ') = ('input-prepend', 'input-append')">
            <xsl:variable name="value" select="concat(preceding-sibling::*[@class = 'add-on']/text(), @value, following-sibling::*[@class = 'add-on']/text())" as="xs:string?"/>
            <xsl:message>Concatenated @value: <xsl:value-of select="$value"/></xsl:message>
            <!-- set the initial value the same way as the event handler does -->
            <ixsl:set-property object="../input[@type = 'hidden']" name="value" select="$value"/>

            <xsl:message>
                <xsl:value-of select="ixsl:call(., 'addEventListener', [ 'change', ixsl:get(ixsl:window(), 'onPrependedAppendedInputChange') ])"/>
            </xsl:message>
        </xsl:if>
        
        <!-- TO-DO: move to a better place. Does not take effect if typeahead is reset -->
        <ixsl:set-property object="." name="autocomplete" select="'off'"/>
    </xsl:template>
    
</xsl:stylesheet>