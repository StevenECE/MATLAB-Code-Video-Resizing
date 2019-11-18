clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
imtool close all;  % Close all imtool figures.
clear;  % Erase all existing variables.
workspace;  % Make sure the workspace panel is showing.

fontSize = 40;

prompt = {'Enter a scale factor:'};
dlgtitle = 'Video Resizing';
answer = inputdlg(prompt,dlgtitle,[1 40]);
shrinkFactor = str2double(answer{1});

[baseFileName, folderName, FilterIndex] = uigetfile('*.avi');
inputFullFileName = fullfile(folderName, baseFileName);

% Load input video info
inputVideoReaderObject = VideoReader(inputFullFileName)
numberOfFrames = inputVideoReaderObject.NumberOfFrames;
inputVideoFrameRate = inputVideoReaderObject.FrameRate;

% Create output video
outputFullFileName = fullfile(pwd, 'Resized.avi');
outputVideoWriterObject = VideoWriter(outputFullFileName);
outputVideoWriterObject.FrameRate = inputVideoFrameRate;
open(outputVideoWriterObject);

numberOfFramesWritten = 0;

% Loop through the movie, writing all frames out
for frame = 1 : numberOfFrames
	% Extract the frame from the movie structure.
	thisInputFrame = read(inputVideoReaderObject, frame);
	
    % Display progress
    image(thisInputFrame);
	axis on;
	axis image;
    percentage = frame / numberOfFrames * 100;
	caption = sprintf('%5.2f%% complete', percentage);
    title(caption, 'FontSize', fontSize);
	drawnow; % Force it to refresh the window.
    
	% Resize the image
	outputFrame = imresize(thisInputFrame, shrinkFactor);
	
	% Write this new, resized frame out to the new video file
	writeVideo(outputVideoWriterObject, outputFrame);
	
	numberOfFramesWritten = numberOfFramesWritten + 1;
end

% Close the output video object
close(outputVideoWriterObject);

outputVideoReaderObject = VideoReader(outputFullFileName)

% Alert user that the compression is done.
finishedMessage = sprintf('Done! %d frames of "%s" are processed, and output video "%s" is created.\nClick OK to see the output video.', numberOfFramesWritten, inputFullFileName, outputFullFileName);
fprintf('%s\n', finishedMessage); % Write to command window
uiwait(msgbox(finishedMessage)); % Also pop up a message box

% Play the movie.
winopen(outputFullFileName);