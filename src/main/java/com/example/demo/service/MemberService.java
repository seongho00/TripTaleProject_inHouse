package com.example.demo.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.repository.MemberRepository;
import com.example.demo.vo.Member;
import com.example.demo.vo.ResultData;

@Service
public class MemberService {

	@Autowired
	private MemberRepository memberRepository;

	public MemberService(MemberRepository memberRepository) {
		this.memberRepository = memberRepository;
	}

	public ResultData doJoin(String loginId, String loginPw, String name, String email) {

		memberRepository.doJoin("local", loginId, loginPw, name, email, null);
		int id = memberRepository.getLastInsertId();

		return ResultData.from("S-1", "로그인 성공", "memberId", id);
	}

	public Member getMemberById(String provider, String providerId) {

		return memberRepository.getMemberById(provider, providerId);
	}

}
