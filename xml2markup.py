#!/usr/bin/python
# -*- coding: utf-8 -*-
import argparse
from lxml import etree
import re
import glob, os, shutil


def img_converter(src_path, destination_path):
	try:
		from PIL import Image
		IMG_CONVERTER = True
	except:
		IMG_CONVERTER = False

	valid_img_ext = ['.eps', '.tif', '.tiff']

	if src_path:
		if IMG_CONVERTER:

			if not os.path.isdir(destination_path):
				os.makedirs(destination_path)

			if os.path.isdir(src_path):
				# print(os.listdir(src_path))
				images = [img for img in os.listdir(src_path) if img[img.rfind('.'):].lower() in valid_img_ext]
				# print(images)

				for img in images:
					name = img[0:img.rfind('.')] + '.jpg'
					
					# print(name)
					not_jpg_img = src_path + '/' + img
					jpg_img = destination_path + '/' + name
					if not os.path.isfile(jpg_img):
						try:
							im = Image.open(not_jpg_img)
							im.thumbnail(im.size)
							im.save(jpg_img, "JPEG", quality=100)
							os.remove(not_jpg_img)
						except Exception as inst:
							print('Unable to convert ')
							print(not_jpg_img)
							print('to')
							print(jpg_img)
							print(inst)
							print('')
					else:
						os.remove(not_jpg_img)
		else:
			print('PIL is not installed.')
	else:
		print('Usage:')
		print('python img_converter.py <images_folder> <jpg_folder>')

def xml2markup(source):
	basepath = os.path.dirname(os.path.dirname(source))
	basename = os.path.splitext(os.path.basename(source))[0]
	srcpath = os.path.join(basepath, 'src')
	scielo_markup = os.path.join(basepath, 'scielo_markup')
	output_file = os.path.join(scielo_markup, basename+'.html')

	# check and create paths
	if not os.path.exists(scielo_markup):
		os.makedirs(scielo_markup)
	if not os.path.exists(srcpath):
		os.makedirs(srcpath)

	dom = etree.parse(source)
	xslt = etree.XSLT(etree.parse('xml2sgml.xsl'))
	newdom = None
	try:
		newdom = xslt(dom)
	except Exception, e:
		print 'xml2sgml.xsl'
		print e
		print source
		exit(1)


	dom = etree.fromstring(re.sub(r'<img src="(.+?)(\.tif|\.tiff|\.eps)"/>', r'<img src="\1.jpg"/>', etree.tostring(newdom, encoding='utf-8')))
	xslt = etree.XSLT(etree.parse('sgml2markup.xsl'))
	try:
		newdom = xslt(dom)
	except Exception, e:
		print 'sgml2markup.xsl'
		print e
		print source
		exit(1)
	# write sgml.xml file
	# with open(os.path.join(scielo_markup, basename+'.sgml.xml'), 'w') as f:
	# 	f.write(etree.tostring(dom))
	# copy source files
	files = glob.iglob(os.path.join(basepath, 'scielo_package', basename+"*.*"))
	for file in files:
		if os.path.isfile(file) and os.path.splitext(os.path.basename(file))[1] != '.xml' and not os.path.isfile(os.path.join(srcpath, os.path.basename(file))):
			# print file
			shutil.copy2(file, srcpath)
	#convert img files
	img_converter(srcpath, srcpath)

	# write file to scielo_markup
	with open(output_file, 'w') as f:
		f.write((etree.tostring(newdom, encoding='utf-8', pretty_print=True, method="xml")))

parser = argparse.ArgumentParser()
parser.add_argument('source', action='store', help='XML file or scielo_package dir')
arguments = parser.parse_args()

if 'markup_xml/scielo_package' not in arguments.source:
	print ('Need markup_xml/scielo_package path struct')

if os.path.isdir(arguments.source):
	files = glob.iglob(os.path.join(arguments.source, "*.xml"))
	for file in files:
		xml2markup(file)
else: 
	xml2markup(arguments.source)

