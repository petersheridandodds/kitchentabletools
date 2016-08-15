#!/usr/bin/perl
# peter sheridan dodds
# (slowly evolving since 1996)
# the script, that is...
# 
# https://github.com/petersheridandodds
# MIT License
# 
# create a template for a matlab figure
# first argument is name of file to be created
# optional second and third arguments give
# number of rows and columns (to be added later)
#
$figfilename = $ARGV[0];
# remove any suffix
$figfilename =~ s/\..*//;

# check to make sure it doesn't exist
if (-e "$figfilename.m")
{
    print "$figfilename.m already exists, no action taken\n";
    exit;
}

print "creating $figfilename.m\n";

($nofigname = $figfilename) =~ s/^fig//;

open (FIGFILE, ">$figfilename.m") or die "can't open $figfilename.m: $!";
print FIGFILE "%% uses ../data/$nofigname.mat
figure('visible','off');
set(gcf,'color','none');
tmpfigh = gcf;
clf;
figshape(500,500);
%% automatically create postscript whenever
%% figure is drawn
tmpfilename = '$figfilename';

tmpfilenoname = sprintf('%s_noname',tmpfilename);

%% global switches

set(gcf,'Color','none');
set(gcf,'InvertHardCopy', 'off');

set(gcf,'DefaultAxesFontname','helvetica');
set(gcf,'Renderer','Painters');

set(gcf,'DefaultAxesColor','none');
set(gcf,'DefaultLineMarkerSize',10);
% set(gcf,'DefaultLineMarkerEdgeColor','k');
set(gcf,'DefaultLineMarkerFaceColor','w');
set(gcf,'DefaultAxesLineWidth',0.5);

set(gcf,'PaperPositionMode','auto');

%% tmpsym = {'ok-','sk-','dk-','vk-','^k-','>k-','<k-','pk-','hk-'};
%% tmpsym = {'k-','r-','b-','m-','c-','g-','y-'};
%% tmpsym = {'k-','k-.','k:','k--','r-','r-.','r:','r--'};
%% tmplw = [ 1.5*ones(1,4), .5*ones(1,4)];


%% create an array of plots
%% xoffset = 0.05;
%% yoffset = 0.05; 
%% width = .30;
%% height = .90; 
%% xsep = 0.02;
%% ysep = 0.02;
%% m = 1; 
%% n = 3;
%% positions = makepositions(xoffset,...
%%                           yoffset,...
%%                           width,...
%%                           height,...
%%                           xsep,...
%%                           ysep,...
%%                           m,...
%%                           n);

positions(1).box = [.20 .20 .70 .50];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% main plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

axesnum = 1;
tmpaxes(axesnum) = axes('position',positions(axesnum).box);

%% tmph = plot(,,'');
%% tmph = loglog(,, '');

set(gca,'fontsize',12);
set(gca,'color','none');

%% for use with layered plots
%% set(gca,'box','off')

%% adjust limits
%% tmpv = axis;
%% axis([]);
%% xlim([]);
%% ylim([]);

%% change axis line width (default is 0.5)
%% set(tmpaxes(axesnum),'linewidth',2)

%% fix up tickmarks
%% set(gca,'xtick',[1 100 10^4])
%% set(gca,'xticklabel',{'','',''})
%% set(gca,'ytick',[1 100 10^4])
%% set(gca,'yticklabel',{'','',''})

%% the following will usually not be printed 
%% in good copy for papers
%% (except for legend without labels)

%% remove a plot from the legend
%% set(get(get(tmph,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');

%% legend
%% tmplh = legend('stuff',...);
%% tmplh = legend('','','');
%% set(tmplh,'position',get(tmplh,'position')-[x y 0 0])
%% change font
%% tmplh = findobj(tmplh,'type','text');
%% set(tmplh,'FontSize',18);
%% remove box:
%% legend boxoff

%% use latex interpreter for text, sans serif

tmpxlab=xlabel(...
    '\\sffamily ',
    'fontsize',16,...
    'verticalalignment','top',...
    'fontname','helvetica',...
    'interpreter','latex');
tmpylab=ylabel(...
    '\\sffamily ',...
    'fontsize',16,...
    'verticalalignment','bottom',...
    'fontname','helvetica',...
    'interpreter','latex');

%% set(tmpxlab,'position',get(tmpxlab,'position') - [0 .1 0]);
%% set(tmpylab,'position',get(tmpylab,'position') - [.1 0 0]);

%% set 'units' to 'data' for placement based on data points
%% set 'units' to 'normalized' for relative placement within axes
%% tmpXcoord = ;
%% tmpYcoord = ;
%% tmpstr = sprintf('\\\\sffamily ');
%% or
%% tmpstr{1} = sprintf('\\\\sffamily ');
%% tmpstr{2} = sprintf('\\\\sffamily ');
%%
%% text(tmpXcoord,tmpYcoord,tmpstr,...
%%     'fontsize',20,...
%%     'fontname','helvetica',...
%%     'units','normalized',...
%%     'interpreter','latex')

%% label (A, B, ...)
%% addlabel2(' A ',0.02,0.9,20);
%% addlabel3(loop_i,0.02,0.9,20);

%% or:
%% tmplabelXcoord= 0.015;
%% tmplabelYcoord= 0.88;
%% tmplabelbgcolor = 0.85;
%% tmph = text(tmplabelXcoord,tmplabelYcoord,' A ','Fontsize',24,'fontname','helvetica',...
%%         'units','normalized');
%%    set(tmph,'backgroundcolor',tmplabelbgcolor*[1 1 1]);
%%    set(tmph,'edgecolor',[0 0 0]);
%%    set(tmph,'linestyle','-');
%%    set(tmph,'linewidth',1);
%%    set(tmph,'margin',1);


%% rarely used (text command is better)
%% title('\\sffamily ','fontsize',24,'interpreter','latex')
%% 'horizontalalignment','left');
%% tmpxl = xlabel('','fontsize',24,'verticalalignment','top');
%% set(tmpxl,'position',get(tmpxl,'position') - [ 0 .1 0]);
%% tmpyl = ylabel('','fontsize',24,'verticalalignment','bottom');
%% set(tmpyl,'position',get(tmpyl,'position') - [ 0.1 0 0]);
%% title('','fontsize',24)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% automatic creation of postscript
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% without name/date
psprintcpdf(tmpfilenoname);

%% uncomment following to keep postscript for some publications
%% psprintcpdf_keeppostscript(tmpfilenoname);

%% name label
%% tmpt = pwd;
%% tmpnamememo = sprintf('[source=%s/%s.ps]',tmpt,tmpfilename);
%% 
%% [tmpXcoord,tmpYcoord] = normfigcoords(1.05,.05);
%% text(tmpXcoord,tmpYcoord,tmpnamememo,...
%%      'units','normalized',...
%%      'fontsize',2,...
%%      'rotation',90,'color',0.8*[1 1 1]);

%% [tmpXcoord,tmpYcoord] = normfigcoords(1.1,.05);
%% datenamer(tmpXcoord,tmpYcoord,90);

%% automatic creation of postscript
%% psprintcpdf(tmpfilename);

tmpcommand = sprintf('open %s.pdf;',tmpfilenoname);
system(tmpcommand);

%% archivify
%% figurearchivify(tmpfilenoname);

close(tmpfigh);
clear tmp*
";

close FIGFILE;




