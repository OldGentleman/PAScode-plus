%% �õ������ļ��б�  
classfilename='PASclasses.txt';
  PASdir='../data/';
  DATdir='VOC2007/';
  DATstr='The Caltech database';
  IMGdir='MACOSX/';
  ORGlabel='JointsRear';
  PNGdir=[PASdir,DATdir,'JPEGImages/',IMGdir];
  % PNGdir=[PASdir,DATdir,'JPEGImages/'];
  ANNdir=[PASdir,DATdir,'Annotations/',IMGdir];
addpath('annotations');  %������ű���ļ���·��  
annotList = dir([ANNdir,'/*.txt']);  %�õ���·���µ�����txt�ļ�  
annotListLen = length(annotList); % txt�ļ�����Ŀ  
  
for i = 1:annotListLen  
    % �� PASCAL Annotaions Ver. 1.00 ���߶�ȡ����  
    fn = strcat(ANNdir, annotList(i).name); %��Ҫ��ȡ���ļ���  
    record = PASreadrecord(fn); %��ȡ����  
      
    % ��ȡ�����������  
    imgname = record.imgname;  
    idx = regexp(imgname,'/');      
    imgsize = record.imgsize;  
    db = 'INRIA';   
    obj = record.objects;  
    object_num = length(obj);  
      
    % ����һ��xml�ļ����洢���ݡ�  
    %������Ҫ�洢��xml�ļ�·������������������Ǵ��ڵ�ǰ����Ŀ¼�µġ�Gen/Test/pos/�ļ���.xml��  
    path_data =  strcat(ANNdir, annotList(i).name(1:end-4));  
    path_data = strcat(path_data, '.xml');   
      
    %���潨���ڵ㣬������������㼶  
    %�������ڵ㣬���Կ����ǵ�һ��  
    annotation = com.mathworks.xml.XMLUtils.createDocument('annotation');  
    annotationRoot = annotation.getDocumentElement;  
      
        %�����ӽڵ㣬���Կ����ǵڶ���  
        folder = annotation.createElement('folder');  
        folder.appendChild(annotation.createTextNode(db));  
        annotationRoot.appendChild(folder);  
  
        filename = annotation.createElement('filename');  
        filename.appendChild(annotation.createTextNode(imgname(idx(2)+1:end)));  
        annotationRoot.appendChild(filename);  
  
        source = annotation.createElement('source');  
        annotationRoot.appendChild(source);  
            %�����õ���ӽڵ㣬����ʱ�ø��ڵ㽨��������Ҫ���������ڵ�����Ǹ��ڵ㣬������Կ���������  
            database = annotation.createElement('database');%�ø��ڵ㽨��  
            database.appendChild(annotation.createTextNode(db));  
            source.appendChild(database);%���������ڵ�  
            annotaion_src = annotation.createElement('annotation');  
            annotaion_src.appendChild(annotation.createTextNode('PASCAL Annotaion Version 1.00'));  
            source.appendChild(annotaion_src);%  
            image = annotation.createElement('image');  
            image.appendChild(annotation.createTextNode('null'));  
            source.appendChild(image);%  
            flickrid_src = annotation.createElement('flickrid');  
            flickrid_src.appendChild(annotation.createTextNode('null'));  
            source.appendChild(flickrid_src);%  
  
        owner = annotation.createElement('owner');  
        annotationRoot.appendChild(owner);  
            flickrid_own = annotation.createElement('flickrid');  
            flickrid_own.appendChild(annotation.createTextNode('null'));  
            owner.appendChild(flickrid_own);%  
            name = annotation.createElement('name');  
            name.appendChild(annotation.createTextNode('null'));  
            owner.appendChild(name);%  
  
        size = annotation.createElement('size');  
        annotationRoot.appendChild(size);  
            width = annotation.createElement('width');  
            width.appendChild(annotation.createTextNode(num2str(imgsize(1))));  
            size.appendChild(width);%  
            height = annotation.createElement('height');  
            height.appendChild(annotation.createTextNode(num2str(imgsize(2))));  
            size.appendChild(height);%  
            depth = annotation.createElement('depth');  
            depth.appendChild(annotation.createTextNode(num2str(imgsize(3))));  
            size.appendChild(depth);%  
  
        segmented = annotation.createElement('segmented');  
        segmented.appendChild(annotation.createTextNode('0'));  
        annotationRoot.appendChild(segmented);  
  
        for j = 1:object_num %%һ��ͼ�п����ж��Ŀ�꣬��Ҫѭ���������object��ע  
            object = annotation.createElement('object');  
            annotationRoot.appendChild(object);  
                name_obj = annotation.createElement('name');  
                name_obj.appendChild(annotation.createTextNode('person'));  
                object.appendChild(name_obj);%  
                pose = annotation.createElement('pose');  
                pose.appendChild(annotation.createTextNode(obj(j).orglabel));  
                object.appendChild(pose);%  
                truncated = annotation.createElement('truncated');  
                truncated.appendChild(annotation.createTextNode('0'));  
                object.appendChild(truncated);%  
                difficult = annotation.createElement('difficult');  
                difficult.appendChild(annotation.createTextNode('0'));  
                object.appendChild(difficult);%  
                bndbox = annotation.createElement('bndbox');  
                object.appendChild(bndbox);%  
                    xmin = annotation.createElement('xmin');  
                    xmin.appendChild(annotation.createTextNode(num2str(obj(j).bbox(1))));  
                    bndbox.appendChild(xmin);%  
                    ymin = annotation.createElement('ymin');  
                    ymin.appendChild(annotation.createTextNode(num2str(obj(j).bbox(2))));  
                    bndbox.appendChild(ymin);%  
                    xmax = annotation.createElement('xmax');  
                    xmax.appendChild(annotation.createTextNode(num2str(obj(j).bbox(3))));  
                    bndbox.appendChild(xmax);%  
                    ymax = annotation.createElement('ymax');  
                    ymax.appendChild(annotation.createTextNode(num2str(obj(j).bbox(4))));  
                    bndbox.appendChild(ymax);%  
        end  
    xmlwrite(path_data,annotation); %% д��xml�ļ�  
end  