package com.example.demo.repository;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface TripLocationPictureRepository {

	public void insertPicture(String pictureUrl, int id);

}
