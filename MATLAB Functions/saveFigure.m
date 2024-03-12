function [] = saveFigure(fig,title,folderName,format,transparent)

% INPUTS
% fig               matlab figure handle
% title             title of the saved file (string)
% folderName        path where the file is to be saved (string)
% format            file format (cell array, options are 'fig', 'png', 'pdf', 'svg')
% transparent       1 if white color is to be made transparent, 0 if no transparency is needed


for i = 1:numel(format)
    fileType = format{i};
    switch fileType
        case 'fig'
            saveas(fig,[folderName + title + '.fig'])
        case 'png'  %sometimes has weird artefacts
            dpi = 800;
            exportgraphics(fig,[folderName + title + '.png'],'Resolution',dpi,'BackgroundColor','current')
            
            % fig.InvertHardcopy = 'off';
            % fig.PaperUnits = 'centimeters';
            % fig.PaperSize = fig.Position(3:4);
            % print(fig,[folderName title],'-dpng','-r800')
            
            if transparent
                warning('If white color is the one that is being made transparent, the final png will have abnormally thin text font')
                trns_col = [1 1 1];
                im = imread(folderName + title + '.png');
                imwrite(im,folderName + title + '.png','Transparency',trns_col);
            end
        case 'pdf'  %does not work very well
            exportgraphics(fig,folderName + title + '.pdf')
        case 'svg'
            saveas(fig,folderName + title + '.svg')
    end
            
end


end

