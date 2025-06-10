package com.example.demo.repository;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.vo.NaverMember;

@Mapper
public interface NaverOAuthRepository {

	public NaverMember getNaverMemberById(String id);
	
	public void doJoin(String id, String name, String email, String profileImage);

}
