package com.example.demo.repository;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.vo.Article;
import com.example.demo.vo.Member;

@Mapper
public interface MemberRepository {

	public void doJoin(String provider, String providerId, String loginPw, String name, String email,
			String profileImage);

	public int getLastInsertId();

	public Member getMemberByLoingId(String loginId);

	public Member getMemberById(String provider, String providerId);

}
